//
//  ViewController.swift
//  PictureMemo
//
//  Created by saito-takumi on 2016/04/27.
//  Copyright © 2016年 saito-takumi. All rights reserved.
//

import UIKit
import CoreData


//noteの情報を受け取るための構造体
struct NoteAttributes {
    var title :String?
    var uiImage :UIImage?
    var memo :String?
}

class TableViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    var notes :[Note] = []
    var deleteNoteIndex :Int?
    var noteAttributes :NoteAttributes?
    var edited :Bool?
    var fontSize :Float?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        //userDefaultsの初期値設定
        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: [Common.FONT_SIZE_KEY_NAME : Common.FontSize.min.rawValue ])
        
        //tableViewの余白を消す
        self.automaticallyAdjustsScrollViewInsets = false;
        
        //coredataからデータを取り出す
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let managedContext = appDelegate?.managedObjectContext {
            let entityDescription = NSEntityDescription.entity(forEntityName: Common.ENTITY_NAME, in: managedContext)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            fetchRequest.entity = entityDescription
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: Common.ENTITY_DATE_KEY_NAME, ascending: false)]
            do {
                let results = try managedContext.fetch(fetchRequest)
                self.notes = results as! [Note]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //色の設定
        let userDefaults = UserDefaults.standard
        if let colorData = userDefaults.object(forKey: Common.COLOR_KEY_NAME) as? Data {
            let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
            navigationController?.navigationBar.barTintColor = color
            tabBarController?.tabBar.barTintColor = color
        }
        //fontSizeの設定
        self.fontSize = userDefaults.float(forKey: Common.FONT_SIZE_KEY_NAME)
        
        //テーブルの更新
        if let noteAttributes = noteAttributes, let title = noteAttributes.title , let image = noteAttributes.uiImage, let memo = noteAttributes.memo {
            //更新の場合
            if let edited = edited, edited , let noteIndex = deleteNoteIndex {
                deleteNote(noteIndex)
            }
            saveNote(title, image: image, memo: memo)
        }

        tableView.reloadData()
        
        edited = nil
        noteAttributes = nil
        deleteNoteIndex = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Common.CELL_NAME, for: indexPath) as! ItemTableViewCell
        let note = notes[indexPath.row]
        if let title = note.title, let image = note.image, let memo = note.memo {
            cell.itemTitleLabel.text = title
            cell.itemImageView.image = UIImage(data: image as Data)
            cell.itemMemoLabel.text = memo

            //font-sizeの設定
            if let fontSize = self.fontSize {
                cell.itemMemoLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
                cell.itemTitleLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
                cell.itemTitleLabel.sizeToFit()
            }
        }
        return cell
    }
    
    //セルを編集可能にする
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //deleteボタンを押した時の処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? ItemTableViewCell {
            if let detailViewController = segue.destination as? DetailViewController {
                if let cellIndex = tableView.indexPathForSelectedRow?.row{
                    detailViewController.note = notes[cellIndex]
                    self.deleteNoteIndex = cellIndex
                }
            }
        }
    }
    
    //coredataからノートの削除
    func deleteNote(_ index :Int){
        let appDelegate  = UIApplication.shared.delegate as? AppDelegate
        let managedContex = appDelegate?.managedObjectContext
        managedContex?.delete(notes[index])
        appDelegate?.saveContext()
        notes.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index,section: 0)], with: UITableViewRowAnimation.fade)
    }
    
    //noteをcoredataに保存する処理
    func saveNote(_ title :String, image: UIImage, memo :String){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let managedContext = appDelegate?.managedObjectContext {
            let managedObject :AnyObject = NSEntityDescription.insertNewObject(forEntityName: Common.ENTITY_NAME, into: managedContext)
            if let model = managedObject as? PictureMemo.Note {
                model.image = UIImagePNGRepresentation(image)
                model.title = title
                model.memo = memo
                model.date = Date()
                
                appDelegate?.saveContext()
                notes.insert(model, at: 0)
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.right)

            }
        }
    }
}


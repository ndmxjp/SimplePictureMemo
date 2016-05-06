//
//  ViewController.swift
//  PictureMemo
//
//  Created by saito-takumi on 2016/04/27.
//  Copyright © 2016年 saito-takumi. All rights reserved.
//

import UIKit
import CoreData
class TableViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    var notes :[Note] = []
    var deleteNoteIndex :Int?
    var noteTitle :String?
    var noteImage :UIImage?
    var noteMemo :String?
    var edited :Bool?
    var fontSize :Float?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableViewの余白を消す
        self.automaticallyAdjustsScrollViewInsets = false;
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        if let managedContext = appDelegate?.managedObjectContext {
            let entityDescription = NSEntityDescription.entityForName("Note", inManagedObjectContext: managedContext)
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = entityDescription
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            do {
                let results = try managedContext.executeFetchRequest(fetchRequest)
                self.notes = results as! [Note]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        //色の設定
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let colorData = userDefaults.objectForKey("color") as? NSData {
            let color = NSKeyedUnarchiver.unarchiveObjectWithData(colorData) as? UIColor
            navigationController?.navigationBar.barTintColor = color
            tabBarController?.tabBar.barTintColor = color
        }
        //fontSizeの設定
        self.fontSize = userDefaults.floatForKey("fontSize")
        
        //テーブルの更新
        if let title = noteTitle, let image = noteImage, let memo = noteMemo {
            if let edited = edited where edited {
                if let noteIndex = deleteNoteIndex {
                    deleteNote(noteIndex)
                }
            }
            saveNote(title, image: image, memo: memo)
        }

        tableView.reloadData()
        
        edited = nil
        noteTitle = nil
        noteImage = nil
        noteMemo = nil
        deleteNoteIndex = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemTableViewCell
        let note = notes[indexPath.row]
        if let title = note.title, let image = note.image, let memo = note.memo {
            cell.itemTitleLabel.text = title
            cell.itemImageView.image = UIImage(data: image)
            cell.itemMemoLabel.text = memo

            if let fontSize = self.fontSize where fontSize != 0.0{
                cell.itemMemoLabel.font = UIFont.systemFontOfSize(CGFloat(fontSize))
                cell.itemTitleLabel.font = UIFont.systemFontOfSize(CGFloat(fontSize))
                cell.itemTitleLabel.sizeToFit()
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteNote(indexPath.row)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let _ = sender as? ItemTableViewCell {
            if let detailViewController = segue.destinationViewController as? DetailViewController {
                if let cellIndex = tableView.indexPathForSelectedRow?.row{
                    detailViewController.note = notes[cellIndex]
                    self.deleteNoteIndex = cellIndex
                }
            }
        }
    }
    
    func deleteNote(index :Int){
        let appDelegate  = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedContex = appDelegate?.managedObjectContext
        managedContex?.deleteObject(notes[index])
        appDelegate?.saveContext()
        notes.removeAtIndex(index)
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index,inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func saveNote(title :String, image: UIImage, memo :String){
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        if let managedContext = appDelegate?.managedObjectContext {
            let managedObject :AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: managedContext)
            if let model = managedObject as? PictureMemo.Note {
                model.image = UIImagePNGRepresentation(image)
                model.title = title
                model.memo = memo
                model.date = NSDate()
                
                appDelegate?.saveContext()
                notes.insert(model, atIndex: 0)
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)

            }
        }
    }
}


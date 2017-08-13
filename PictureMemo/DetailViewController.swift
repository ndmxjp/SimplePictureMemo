//
//  DetailViewController.swift
//  PictureMemo
//
//  Created by saito-takumi on 2016/04/29.
//  Copyright © 2016年 saito-takumi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var memoTextView: UITextView!
    
    var note :Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let note = note ,let image = note.image{
            titleLabel.text = note.title
            imageView.image = UIImage(data: image as Data)
            memoTextView.text = note.memo
        }
        
        //枠線を設定
        memoTextView.layer.borderWidth = CGFloat(Common.BorderWidth.size.rawValue)

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
        let fontSize = userDefaults.float(forKey: Common.FONT_SIZE_KEY_NAME)
        titleLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        titleLabel.sizeToFit()
        memoTextView.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addNotelViewController = segue.destination as? AddNoteViewController {
            if let note = note {
                addNotelViewController.note = note
            }
        }
    }
    
}

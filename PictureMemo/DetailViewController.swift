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
            imageView.image = UIImage(data: image)
            memoTextView.text = note.memo
        }
        
        //枠線を設定
        memoTextView.layer.borderWidth = 1.0
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
        let fontSize = userDefaults.floatForKey("fontSize")
        titleLabel.font = UIFont.systemFontOfSize(CGFloat(fontSize))
        titleLabel.sizeToFit()
        memoTextView.font = UIFont.systemFontOfSize(CGFloat(fontSize))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let addNotelViewController = segue.destinationViewController as? AddNoteViewController {
            if let note = note {
                addNotelViewController.note = note
            }
        }
    }
    
}

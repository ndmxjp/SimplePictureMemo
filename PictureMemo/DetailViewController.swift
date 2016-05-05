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
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let addNotelViewController = segue.destinationViewController as? AddNoteViewController {
            if let note = note {
                addNotelViewController.note = note
            }
        }
    }
    
}

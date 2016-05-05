//
//  AddMemoViewController.swift
//  PictureMemo
//
//  Created by saito-takumi on 2016/04/27.
//  Copyright © 2016年 saito-takumi. All rights reserved.
//

import UIKit
import CoreData
class AddNoteViewController :UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    

    var note :Note?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var memoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let note = note , let image = note.image{
            titleTextField.text = note.title
            imageView.image = UIImage(data: image)
            memoTextView.text = note.memo
        }
    }
    
    
    @IBAction func tapSellectImageButton(sender: AnyObject) {
        pickImageFromLibrary()
    }
    
    //    ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    //    写真を選択した時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if info[UIImagePickerControllerOriginalImage] != nil {
            imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tapSaveButton(sender: AnyObject) {
        guard let title = titleTextField.text where title != "", let image = imageView.image, let memo = memoTextView.text where memo != "" else {
            
            //アラートダイアログ生成
            let alertController = UIAlertController(title: "error", message: "入力していない項目があります", preferredStyle: UIAlertControllerStyle.Alert)
            //okボタンを追加
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            //アラートダイアログを表示
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        let tableViewController = navigationController?.viewControllers.first as? TableViewController
        tableViewController?.noteTitle = title
        tableViewController?.noteImage = image
        tableViewController?.noteMemo = memo
        tableViewController?.edited = true
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
}

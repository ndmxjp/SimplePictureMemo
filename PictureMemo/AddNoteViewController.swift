//
//  AddMemoViewController.swift
//  PictureMemo
//
//  Created by saito-takumi on 2016/04/27.
//  Copyright © 2016年 saito-takumi. All rights reserved.
//

import UIKit
import CoreData

extension UIImagePickerController {
    public override func shouldAutorotate() -> Bool {
        return true
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
}

class AddNoteViewController :UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    

    var note :Note?
    var activeTextView :Bool? = false
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewA: UIView!
    @IBOutlet weak var viewB: UIView!
    @IBOutlet weak var viewCtopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewCtopLayoutConstraitLandscape: NSLayoutConstraint!
    
    @IBOutlet weak var viewCLeadingConstraint: NSLayoutConstraint!
    override func viewDidLoad() {

        super.viewDidLoad()
        memoTextView.delegate = self
        
        //現在のノートの情報をセット
        if let note = note , let image = note.image {
            titleTextField.text = note.title
            imageView.image = UIImage(data: image)
            memoTextView.text = note.memo
            
            placeHolderLabel.hidden = true
        }
        
        
        //枠線を設定
        memoTextView.layer.borderWidth = CGFloat(Common.BorderWidth.Size.rawValue)
        imageView.layer.borderWidth = CGFloat(Common.BorderWidth.Size.rawValue)
        
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        kbToolBar.barStyle = UIBarStyle.Default  // スタイルを設定
        
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(AddNoteViewController.commitButtonTapped))
        
        kbToolBar.items = [spacer, commitButton]

        //キーボードにdoneボタンを追加
        titleTextField.inputAccessoryView = kbToolBar
        memoTextView.inputAccessoryView = kbToolBar

        //layoutが崩れるのを防ぐ
        self.viewWillAppear(false)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //色の設定
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let colorData = userDefaults.objectForKey(Common.COLOR_KEY_NAME) as? NSData {
            let color = NSKeyedUnarchiver.unarchiveObjectWithData(colorData) as? UIColor
            navigationController?.navigationBar.barTintColor = color
            tabBarController?.tabBar.barTintColor = color
        }
        //fontSizeの設定
        let fontSize = userDefaults.floatForKey(Common.FONT_SIZE_KEY_NAME)
        titleTextField.font = UIFont.systemFontOfSize(CGFloat(fontSize))
        memoTextView.font = UIFont.systemFontOfSize(CGFloat(fontSize))
        placeHolderLabel.font = UIFont.systemFontOfSize(CGFloat(fontSize))
        placeHolderLabel.sizeToFit()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(AddNoteViewController.keyboardWillChangeFrame(_:)),
                                                         name: UIKeyboardWillChangeFrameNotification,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(AddNoteViewController.keyboardWillHide(_:)),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)
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
        
        //tableViewControllerにnoteの値をセット
        let tableViewController = navigationController?.viewControllers.first as? TableViewController
        tableViewController?.noteAttributes = NoteAttributes(title: title, uiImage: image, memo: memo)
        tableViewController?.edited = true
        
        //tableViewに戻る
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func keyboardWillChangeFrame(notification: NSNotification){
        //textViewが選択された時
        if let userInfo = notification.userInfo , let active = activeTextView where active == true{
            guard let tabBarHeight = self.tabBarController?.tabBar.frame.size.height else{
                return
            }
            //constraintを変化させviewをずらす
            let keyBoardValue : NSValue = userInfo[UIKeyboardFrameEndUserInfoKey]! as! NSValue
            let keyBoardFrame : CGRect = keyBoardValue.CGRectValue()
            let duration : NSTimeInterval = userInfo[UIKeyboardAnimationDurationUserInfoKey]! as! NSTimeInterval
            
            //キーボードの高さ分viewを上げる
            self.bottomLayoutConstraint.constant = keyBoardFrame.height - tabBarHeight
            
            //縦画面の処理
            self.viewCtopLayoutConstraint.constant = -(viewA.layer.bounds.height + viewB.layer.bounds.height )
            
            //横画面の処理
            self.viewCtopLayoutConstraitLandscape.constant = -viewA.layer.bounds.height
            self.viewCLeadingConstraint.constant = -viewB.layer.bounds.width
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            
            let duration : NSTimeInterval = userInfo[UIKeyboardAnimationDurationUserInfoKey]! as! NSTimeInterval
            //viewを元の位置に戻す
            self.bottomLayoutConstraint.constant = 0
            self.viewCtopLayoutConstraint.constant = 0
            self.viewCtopLayoutConstraitLandscape.constant = 0
            self.viewCLeadingConstraint.constant = 0

            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    //doneボタンが押された時の処理
    func commitButtonTapped (){
        self.view.endEditing(true)
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        placeHolderLabel.hidden = true
        activeTextView = true
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if memoTextView.text.isEmpty {
            placeHolderLabel.hidden = false
        }
        activeTextView = false
        return true
    }
}

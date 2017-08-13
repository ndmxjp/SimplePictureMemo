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
    open override var shouldAutorotate : Bool {
        return true
    }
    
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
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
            imageView.image = UIImage(data: image as Data)
            memoTextView.text = note.memo
            
            placeHolderLabel.isHidden = true
        }
        
        
        //枠線を設定
        memoTextView.layer.borderWidth = CGFloat(Common.BorderWidth.size.rawValue)
//        imageView.layer.borderWidth = CGFloat(Common.BorderWidth.Size.rawValue)
        
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AddNoteViewController.commitButtonTapped))
        
        kbToolBar.items = [spacer, commitButton]

        //キーボードにdoneボタンを追加
        titleTextField.inputAccessoryView = kbToolBar
        memoTextView.inputAccessoryView = kbToolBar

        //layoutが崩れるのを防ぐ
        self.viewWillAppear(false)

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
        titleTextField.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        memoTextView.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        placeHolderLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        placeHolderLabel.sizeToFit()
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(AddNoteViewController.keyboardWillChangeFrame(_:)),
                                                         name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                                         object: nil)
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(AddNoteViewController.keyboardWillHide(_:)),
                                                         name: NSNotification.Name.UIKeyboardWillHide,
                                                         object: nil)
    }
    
    
    @IBAction func tapSellectImageButton(_ sender: AnyObject) {
        pickImageFromLibrary()
    }
    
    //    ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    //    写真を選択した時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if info[UIImagePickerControllerOriginalImage] != nil {
            imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSaveButton(_ sender: AnyObject) {
        guard let title = titleTextField.text, title != "", let image = imageView.image, let memo = memoTextView.text, memo != "" else {
            
            //アラートダイアログ生成
            let alertController = UIAlertController(title: "error", message: "入力していない項目があります", preferredStyle: UIAlertControllerStyle.alert)
            //okボタンを追加
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(okAction)
            //アラートダイアログを表示
            present(alertController, animated: true, completion: nil)
            return
        }
        
        //tableViewControllerにnoteの値をセット
        let tableViewController = navigationController?.viewControllers.first as? TableViewController
        tableViewController?.noteAttributes = NoteAttributes(title: title, uiImage: image, memo: memo)
        tableViewController?.edited = true
        
        //tableViewに戻る
        navigationController?.popToRootViewController(animated: true)
    }
    
    func keyboardWillChangeFrame(_ notification: Notification){
        //textViewが選択された時
        if let userInfo = notification.userInfo , let active = activeTextView, active == true{
            guard let tabBarHeight = self.tabBarController?.tabBar.frame.size.height else{
                return
            }
            //constraintを変化させviewをずらす
            let keyBoardValue : NSValue = userInfo[UIKeyboardFrameEndUserInfoKey]! as! NSValue
            let keyBoardFrame : CGRect = keyBoardValue.cgRectValue
            let duration : TimeInterval = userInfo[UIKeyboardAnimationDurationUserInfoKey]! as! TimeInterval
            
            //キーボードの高さ分viewを上げる
            self.bottomLayoutConstraint.constant = keyBoardFrame.height - tabBarHeight
            
            //縦画面の処理
            self.viewCtopLayoutConstraint.constant = -(viewA.layer.bounds.height + viewB.layer.bounds.height )
            
            //横画面の処理
            self.viewCtopLayoutConstraitLandscape.constant = -viewA.layer.bounds.height
            self.viewCLeadingConstraint.constant = -viewB.layer.bounds.width
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
            
        }
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            
            let duration : TimeInterval = userInfo[UIKeyboardAnimationDurationUserInfoKey]! as! TimeInterval
            //viewを元の位置に戻す
            self.bottomLayoutConstraint.constant = 0
            self.viewCtopLayoutConstraint.constant = 0
            self.viewCtopLayoutConstraitLandscape.constant = 0
            self.viewCLeadingConstraint.constant = 0

            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    //doneボタンが押された時の処理
    func commitButtonTapped (){
        self.view.endEditing(true)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        placeHolderLabel.isHidden = true
        activeTextView = true
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if memoTextView.text.isEmpty {
            placeHolderLabel.isHidden = false
        }
        activeTextView = false
        return true
    }
}

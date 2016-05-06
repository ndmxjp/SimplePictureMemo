//
//  SettingsViewController.swift
//  PictureMemo
//
//  Created by saito-takumi on 2016/05/05.
//  Copyright © 2016年 saito-takumi. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var cyanButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    
    enum ButtonTag :Int {
        case Orange
        case Cyan
        case Green
        case White
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderWidth = CGFloat(2.0)
        
        whiteButton.addTarget(self, action: #selector(SettingsViewController.tapEvent(_:)), forControlEvents: .TouchUpInside)
        whiteButton.tag = ButtonTag.White.rawValue
        whiteButton.layer.borderWidth = borderWidth
        
        orangeButton.addTarget(self, action: #selector(SettingsViewController.tapEvent(_:)), forControlEvents: .TouchUpInside)
        orangeButton.tag = ButtonTag.Orange.rawValue
        orangeButton.layer.borderWidth = borderWidth
        
        cyanButton.addTarget(self, action: #selector(SettingsViewController.tapEvent(_:)), forControlEvents: .TouchUpInside)
        cyanButton.tag = ButtonTag.Cyan.rawValue
        cyanButton.layer.borderWidth = borderWidth
        
        greenButton.addTarget(self, action: #selector(SettingsViewController.tapEvent(_:)), forControlEvents: .TouchUpInside)
        greenButton.tag = ButtonTag.Green.rawValue
        greenButton.layer.borderWidth = borderWidth
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
    }
    
    func tapEvent(sender: UIButton){
        let color :UIColor
        guard let tag = ButtonTag(rawValue: sender.tag) else {
            return
        }
        switch tag {
        case .White:
            color = UIColor.whiteColor()
        case .Orange:
            color = UIColor.orangeColor()
        case .Cyan:
            color = UIColor.cyanColor()
        case .Green:
            color = UIColor.greenColor()
        }
        
        //色の設定
        navigationController?.navigationBar.barTintColor = color
        tabBarController?.tabBar.barTintColor = color
        
        //userDfaultsに色の情報を保存
        let colorData = NSKeyedArchiver.archivedDataWithRootObject(color)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(colorData, forKey: "color")
        userDefaults.synchronize()
        super.viewDidLoad()
    }
    
    @IBAction func changeSliderValue(sender: AnyObject) {
        let fontSize = convert(slider.value)
        textLabel.font = UIFont.systemFontOfSize(CGFloat(fontSize))
        textLabel.sizeToFit()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setFloat(fontSize, forKey: "fontSize")
        userDefaults.synchronize()
    }
    
    func convert(value :Float) -> Float{
        let min = 17.0
        let max = 40.0
        return value * Float(max - min) + Float(min)
    }
    
}
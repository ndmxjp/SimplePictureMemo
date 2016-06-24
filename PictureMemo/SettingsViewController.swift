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
    @IBOutlet weak var alizarinButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var peterRiverButton: UIButton!
    @IBOutlet weak var turquoiseButton: UIButton!
    
    enum ButtonTag :Int {
        case Orange
        case PeterRiver
        case Turquoise
        case Alizarin
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sliderValueの設定
        let userDefaults = NSUserDefaults.standardUserDefaults()
        slider.value = userDefaults.floatForKey(Common.SLIDER_VALUE_KEY_NAME)
        
        let borderWidth = CGFloat(2.0)
        
        alizarinButton.addTarget(self, action: #selector(SettingsViewController.tapEvent(_:)), forControlEvents: .TouchUpInside)
        alizarinButton.tag = ButtonTag.Alizarin.rawValue
        alizarinButton.layer.borderWidth = borderWidth
        
        orangeButton.addTarget(self, action: #selector(SettingsViewController.tapEvent(_:)), forControlEvents: .TouchUpInside)
        orangeButton.tag = ButtonTag.Orange.rawValue
        orangeButton.layer.borderWidth = borderWidth
        
        peterRiverButton.addTarget(self, action: #selector(SettingsViewController.tapEvent(_:)), forControlEvents: .TouchUpInside)
        peterRiverButton.tag = ButtonTag.PeterRiver.rawValue
        peterRiverButton.layer.borderWidth = borderWidth
        
        turquoiseButton.addTarget(self, action: #selector(SettingsViewController.tapEvent(_:)), forControlEvents: .TouchUpInside)
        turquoiseButton.tag = ButtonTag.Turquoise.rawValue
        turquoiseButton.layer.borderWidth = borderWidth
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
        case .Alizarin:
            color = Common.AlizarinColor
        case .Orange:
            color = Common.OrangeColor
        case .PeterRiver:
            color = Common.PeterRiverColor
        case .Turquoise:
            color = Common.TurquoiseColor

        }
        
        //色の設定
        navigationController?.navigationBar.barTintColor = color
        tabBarController?.tabBar.barTintColor = color
        
        //userDefaultsに色の情報を保存
        let colorData = NSKeyedArchiver.archivedDataWithRootObject(color)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(colorData, forKey: Common.COLOR_KEY_NAME)
        userDefaults.synchronize()
        super.viewDidLoad()
    }
    
    @IBAction func changeSliderValue(sender: AnyObject) {
        let fontSize = convert(slider.value)
        textLabel.font = UIFont.systemFontOfSize(CGFloat(fontSize))
        
        //userDefaultsにfont-sizeの情報を保存
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setFloat(fontSize, forKey: Common.FONT_SIZE_KEY_NAME)
        userDefaults.setFloat(slider.value, forKey: Common.SLIDER_VALUE_KEY_NAME)
        userDefaults.synchronize()
    }
    
    func convert(value :Float) -> Float{
        let min = Common.FontSize.min.rawValue
        let max = Common.FontSize.max.rawValue
        return value * Float(max - min) + Float(min)
    }
    
}
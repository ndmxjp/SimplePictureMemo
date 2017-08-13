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
        case orange
        case peterRiver
        case turquoise
        case alizarin
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sliderValueの設定
        let userDefaults = UserDefaults.standard
        slider.value = userDefaults.float(forKey: Common.SLIDER_VALUE_KEY_NAME)
        
        let borderWidth = CGFloat(2.0)
        
        alizarinButton.addTarget(self, action: #selector(SettingsViewController.tapEvent(_:)), for: .touchUpInside)
        alizarinButton.tag = ButtonTag.alizarin.rawValue
        alizarinButton.layer.borderWidth = borderWidth
        
        orangeButton.addTarget(self, action: #selector(SettingsViewController.tapEvent(_:)), for: .touchUpInside)
        orangeButton.tag = ButtonTag.orange.rawValue
        orangeButton.layer.borderWidth = borderWidth
        
        peterRiverButton.addTarget(self, action: #selector(SettingsViewController.tapEvent(_:)), for: .touchUpInside)
        peterRiverButton.tag = ButtonTag.peterRiver.rawValue
        peterRiverButton.layer.borderWidth = borderWidth
        
        turquoiseButton.addTarget(self, action: #selector(SettingsViewController.tapEvent(_:)), for: .touchUpInside)
        turquoiseButton.tag = ButtonTag.turquoise.rawValue
        turquoiseButton.layer.borderWidth = borderWidth
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //色の設定
        let userDefaults = UserDefaults.standard
        if let colorData = userDefaults.object(forKey: "color") as? Data {
            let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
            navigationController?.navigationBar.barTintColor = color
            tabBarController?.tabBar.barTintColor = color
        }
    }
    
    func tapEvent(_ sender: UIButton){
        let color :UIColor
        guard let tag = ButtonTag(rawValue: sender.tag) else {
            return
        }
        switch tag {
        case .alizarin:
            color = Common.AlizarinColor
        case .orange:
            color = Common.OrangeColor
        case .peterRiver:
            color = Common.PeterRiverColor
        case .turquoise:
            color = Common.TurquoiseColor

        }
        
        //色の設定
        navigationController?.navigationBar.barTintColor = color
        tabBarController?.tabBar.barTintColor = color
        
        //userDefaultsに色の情報を保存
        let colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        let userDefaults = UserDefaults.standard
        userDefaults.set(colorData, forKey: Common.COLOR_KEY_NAME)
        userDefaults.synchronize()
        super.viewDidLoad()
    }
    
    @IBAction func changeSliderValue(_ sender: AnyObject) {
        let fontSize = convert(slider.value)
        textLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        
        //userDefaultsにfont-sizeの情報を保存
        let userDefaults = UserDefaults.standard
        userDefaults.set(fontSize, forKey: Common.FONT_SIZE_KEY_NAME)
        userDefaults.set(slider.value, forKey: Common.SLIDER_VALUE_KEY_NAME)
        userDefaults.synchronize()
    }
    
    func convert(_ value :Float) -> Float{
        let min = Common.FontSize.min.rawValue
        let max = Common.FontSize.max.rawValue
        return value * Float(max - min) + Float(min)
    }
    
}

//
//  Common.swift
//  PictureMemo
//
//  Created by saito-takumi on 2016/05/16.
//  Copyright © 2016年 saito-takumi. All rights reserved.
//
import UIKit

class Common {
    static let FONT_SIZE_KEY_NAME = "fontSize"
    static let COLOR_KEY_NAME = "color"
    static let SLIDER_VALUE_KEY_NAME = "sliderValue"
    static let ENTITY_NAME = "Note"
    static let ENTITY_DATE_KEY_NAME = "date"
    static let CELL_NAME = "itemCell"
    static let AlizarinColor =  UIColor(red: 233/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1.1)
    static let OrangeColor = UIColor(red: 243/255.0, green: 156/255.0, blue: 18/255.0, alpha: 1.0)
    static let PeterRiverColor =  UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
    static let TurquoiseColor = UIColor(red: 26/255.0, green: 188/255.0, blue: 156/255.0, alpha: 1.0)
    //font-sizeの最大と最小の定義
    enum FontSize :Float{
        case max = 30.0
        case min = 17.0
    }
    
    enum BorderWidth :Float{
        case size = 1.0
    }
}

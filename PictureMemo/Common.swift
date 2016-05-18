//
//  Common.swift
//  PictureMemo
//
//  Created by saito-takumi on 2016/05/16.
//  Copyright © 2016年 saito-takumi. All rights reserved.
//

class Common {
    static let FONT_SIZE_KEY_NAME = "fontSize"
    static let COLOR_KEY_NAME = "color"
    static let SLIDER_VALUE_KEY_NAME = "sliderValue"
    static let ENTITY_NAME = "Note"
    static let ENTITY_DATE_KEY_NAME = "date"
    static let CELL_NAME = "itemCell"
    
    //font-sizeの最大と最小の定義
    enum FontSize :Float{
        case max = 30.0
        case min = 17.0
    }
    
    enum BorderWidth :Float{
        case Size = 1.0
    }
}

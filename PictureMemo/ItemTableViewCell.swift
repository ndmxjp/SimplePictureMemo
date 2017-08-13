//
//  ItemCell.swift
//  PictureMemo
//
//  Created by saito-takumi on 2016/04/27.
//  Copyright © 2016年 saito-takumi. All rights reserved.
//

import UIKit

class ItemTableViewCell : UITableViewCell {
    
    

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemMemoLabel: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        //元々入っている情報を再利用時にクリア
        itemImageView.image = nil
    }

}

//
// TextCardViewCell.swift
// eyeApp
//
// Create by 周涛 on 2018/11/16.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import Foundation

class TextCardViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var attentionBtn: UIButton!
    
    var textCardModel: TextCardModel! {
        didSet {
            self.titleLabel.text = self.textCardModel.data.text
        }
    }
    
    override func awakeFromNib() {
        
    }
}

//
// FollowCardView.swift
// eyeApp
//
// Create by 周涛 on 2018/11/16.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import Foundation

class FollowCardViewCell: UITableViewCell {
    @IBOutlet weak var coverPicture: UIImageView!
    @IBOutlet weak var headPicture: UIImageView!
    @IBOutlet weak var headTitle: UILabel!
    @IBOutlet weak var headSubTitle: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    
    var followCardModel: FollowCardModel! {
        didSet {
            self.headPicture.yy_setImage(with: URL(string: self.followCardModel.data.header.icon), options: YYWebImageOptions.progressiveBlur)
            self.headTitle.text = self.followCardModel.data.header.title
            self.headSubTitle.text = self.followCardModel.data.header.description
            self.coverPicture.yy_setImage(with: URL(string: (self.followCardModel.data.content.data.cover?.feed)!), options: YYWebImageOptions.progressiveBlur)
        }
    }
    
    override func awakeFromNib() {
        
    }
}

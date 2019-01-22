//
// SquareCardView.swift
// eyeApp
//
// Create by 周涛 on 2018/11/6.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import Foundation

class SquareCardView: UIView {
    @IBOutlet weak var profile_Photo: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    var followCardModel: FollowCardModel! {
        didSet{
            
            let header = self.followCardModel.data.header
            let content = self.followCardModel.data.content
            self.profile_Photo.yy_setImage(with:URL(string: header.icon) , options: YYWebImageOptions.progressiveBlur)
            self.profile_Photo.layer.cornerRadius = 20
            self.profile_Photo.layer.masksToBounds = true
            self.title.text = header.title
            self.descriptionTitle.text = header.description
            self.coverImage.yy_setImage(with: URL(string: content.data.cover!.feed), options: YYWebImageOptions.progressiveBlur)
        }
    }
}

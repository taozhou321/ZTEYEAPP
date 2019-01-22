//
// VideoSmallCardViewCell.swift
// eyeApp
//
// Create by 周涛 on 2018/11/16.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import Foundation

class VideoSmallCardViewCell: UITableViewCell {
    @IBOutlet weak var coverPicture: UIImageView!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var videoSmallCardModel: VideoSmallCardModel! {
        didSet {
            self.coverPicture.yy_setImage(with: URL(string: self.videoSmallCardModel.data.cover.feed), options: YYWebImageOptions.progressiveBlur)
            self.descriptionTitle.text = self.videoSmallCardModel.data.title
            self.categoryLabel.text = self.videoSmallCardModel.data.category
            
        }
    }
    
    override func awakeFromNib() {
        
    }
}

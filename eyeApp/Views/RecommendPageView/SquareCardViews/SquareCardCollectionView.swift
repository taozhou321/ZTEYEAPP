//
// SquareCardCollectionView.swift
// eyeApp
//
// Create by 周涛 on 2018/11/7.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

let squardCollectionCellidentifier = "SquardCollectionCellidentifier"

class SquareCardCollectionCell: UICollectionViewCell {
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var profile_Photo: UIImageView! //头像
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    
    var followCardModel: FollowCardModel! {
        didSet{
            
            let header = self.followCardModel.data.header
            let content = self.followCardModel.data.content
            self.profile_Photo.yy_setImage(with:URL(string: header.icon) , options: YYWebImageOptions.progressiveBlur)
            self.profile_Photo.layer.cornerRadius = 20
            self.profile_Photo.layer.masksToBounds = true
            self.titleLabel.text = header.title
            self.descriptionTextLabel.text = header.description
            self.selectionImageView.yy_setImage(with: URL(string: content.data.cover!.feed), options: YYWebImageOptions.progressiveBlur)
        }
    }
    
}

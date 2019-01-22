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
    @IBOutlet weak var subTitle: UILabel!
    
    var squareCardModel: SquareCardModel! {
        didSet{
           //self.profile_Photo.yy_setImage(with: URL(strin), options: <#T##YYWebImageOptions#>)
        }
    }
}

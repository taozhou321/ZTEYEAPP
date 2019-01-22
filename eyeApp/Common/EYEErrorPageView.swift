//
// EYEErrorPageView.swift
// eyeApp
//
// Create by 周涛 on 2018/10/26.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import SnapKit

class EYEErrorPageView: UIButton {
    /*init(frame: CGRect, type: UIButtonType) {
        super.init(type: type)
        self.frame = frame
        self.imageView?.image = #imageLiteral(resourceName: "ic_loading_error")
        self.titleLabel?.text = "网络错误，请点击重试"
        self.backgroundColor = UIColor.cyan
        
    }*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(#imageLiteral(resourceName: "ic_loading_error"), for: UIControlState.normal)
        self.setTitle("网络错误，请点击重试", for: UIControlState.normal)
        self.setTitleColor(UIConstant.UI_GRAY, for: UIControlState.normal)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setImageAndTitle(frame: CGRect) {
        self.frame = frame
        self.setImage(#imageLiteral(resourceName: "ic_loading_error"), for: UIControlState.normal)
        self.setTitle("网络错误，请点击重试", for: UIControlState.normal)
       
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.adjustPosition(btnImagePositionType: .Top, distance: 10)//图片在上，文字在下
    }
    
    
}

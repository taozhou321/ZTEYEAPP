//
// EYELunchView.swift
// eyeApp
//
// Create by 周涛 on 2018/10/9.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit

class EYELunchView: UIView {
    @IBOutlet weak var blackBgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        
    }
    
    class func lunchView() -> EYELunchView? {
        return Bundle.main.loadNibNamed("EYELunchView", owner: nil, options: nil)?.first as? EYELunchView
    }
    
    
    
    //MARK:- private method
    private func startLunchAnimation() {
        UIView.animate(withDuration: 5, delay: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.blackBgView.alpha = 0
        }) { [unowned self](_) in
            
        }
    }
    
    //动画完成时的回调
}

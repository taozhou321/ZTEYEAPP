//
// EYELunchView.swift
// eyeApp
//
// Create by 周涛 on 2018/10/9.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit

class EYELaunchView: UIView {
    @IBOutlet weak var blackBgView: UIView!
    @IBOutlet weak var imageView: UIImageView!

    
    // 动画完成回调
    typealias AnimationDidStopCallBack = (_ launchView : EYELaunchView) -> Void
    var callBack : AnimationDidStopCallBack?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        startLunchAnimation()
    }
    
    class func launchView() -> EYELaunchView? {
        return Bundle.main.loadNibNamed("EYELaunchView", owner: nil, options: nil)?.first as? EYELaunchView
    }
    
    
    
    //MARK:- private method
    private func startLunchAnimation() {
        UIView.animate(withDuration: 5, delay: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.blackBgView.alpha = 0
        }) { [unowned self](_) in
            self.blackBgView.removeFromSuperview()
            if let cb = self.callBack {
                cb(self)
            }
        }
    }
    
    //动画完成时的回调
    /**
     动画完成时回调
     */
    func animationDidStop(callBack: AnimationDidStopCallBack?) {
        self.callBack = callBack
    }
}

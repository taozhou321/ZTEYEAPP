//
// EYELoadingPageView.swift
// eyeApp
//
// Create by 周涛 on 2018/10/29.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit

class EYELoadingPageView: UIView {
    private var loadingImageView: UIImageView!
    private var loading_in_layer: CALayer!
    private var loading_out_layer: CALayer!
    private var loading_out_layer_2: CALayer!
    private var loading_out_layer_3: CALayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       /* self.loadingImageView = UIImageView(frame: self.bounds)
        self.loadingImageView.image = #imageLiteral(resourceName: "ICON_Loading_Out")
        self.loadingImageView.layer.position = self.center
        self.addSubview(self.loadingImageView)*/
        self.loading_out_layer = CALayer()
        self.loading_out_layer.bounds = self.bounds
        self.loading_out_layer.position = self.center
        self.loading_out_layer.contents = ( #imageLiteral(resourceName: "ICON_Loading_Out")).cgImage
        //self.loading_out_layer.backgroundColor = UIColor.red.cgColor
       
    
        self.loading_in_layer = CALayer()
        self.loading_in_layer.bounds = self.bounds
        self.loading_in_layer.contents = #imageLiteral(resourceName: "ICON_Loading_In").cgImage
        self.loading_in_layer.position = self.center
       
        
        self.loading_out_layer_2 = CALayer()
        self.loading_out_layer_2.bounds = self.bounds
        self.loading_out_layer_2.contents = #imageLiteral(resourceName: "ICON_Loading_Out").cgImage
        self.loading_out_layer_2.opacity = 0.6
        self.loading_out_layer_2.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi / 3))
        
        
        self.loading_out_layer_2.position = self.center
        
        self.loading_out_layer_3 = CALayer()
        self.loading_out_layer_3.bounds = self.bounds
        self.loading_out_layer_3.contents = #imageLiteral(resourceName: "ICON_Loading_Out").cgImage
        self.loading_out_layer_3.opacity = 0.3
        self.loading_out_layer_3.setAffineTransform(CGAffineTransform(rotationAngle: 2 * CGFloat.pi / 3))
        
        self.loading_out_layer_3.position = self.center
        
        self.layer.addSublayer(self.loading_out_layer_3)
        self.layer.addSublayer(self.loading_out_layer_2)
         self.layer.addSublayer(self.loading_out_layer)
         self.layer.addSublayer(self.loading_in_layer)
        
    }
    
    func startLoadingAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 2
        animation.repeatCount = Float(Int.max)
        animation.fillMode = kCAFillModeForwards
        self.layer.add(animation, forKey: "loading_rotation_animation")
        /*self.loading_out_layer.add(animation, forKey: "loading_rotation_animation")
       
        
        let whiteLayer_animation = CABasicAnimation(keyPath: "transform.rotation.z")
        whiteLayer_animation.fromValue = 0
        whiteLayer_animation.toValue = CGFloat.pi * 2
        whiteLayer_animation.duration = 1
        whiteLayer_animation.repeatCount = Float(Int.max)
        whiteLayer_animation.fillMode = kCAFillModeForwards
        //self.loadingImageView.layer.anchorPoint = self.center
        self.loading_white_layer.add(whiteLayer_animation, forKey: "loading_rotation_white_animation")*/
        
    }
    
    func stopLoadingAnimation() {
        self.layer.removeAnimation(forKey: "loading_rotation_animation") //移除动画
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

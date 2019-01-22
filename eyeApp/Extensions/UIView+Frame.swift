//
// UIView+Frame.swift
// eyeApp
//
// Create by 周涛 on 2018/10/26.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import Foundation

extension UIView {
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.width
        }
        
        set {
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.height
        }
        
        set {
            self.frame.size.height = newValue
        }
    }
    
    public var size : CGSize {
        get {
            return self.frame.size
        }
        
        set {
            self.frame.size = newValue
        }
    }
    
    public var origin : CGPoint {
        get {
            return self.frame.origin
        }
        
        set {
            self.frame.origin = newValue
        }
    }
    
    //中心在父视图中的位置
    var centerInSuperView: CGPoint {
        get {
            let centerX = self.center.x + self.x
            let centerY = self.center.y + self.y
            return CGPoint(x: centerX, y: centerY)
        }
        
    }
    

}


//
//  UIScrollView_EX.swift
//  RefreshDemo
//
//  Created by 络威信 on 2019/1/7.
//  Copyright © 2019 周涛. All rights reserved.
//

import UIKit

extension UIScrollView {
    var insetTop: CGFloat {
        get {
            return self.contentInset.top
        }
        set {
            self.contentInset.top = newValue
        }
    }
    
    var insetBottom: CGFloat {
        get {
            return self.contentInset.bottom
        }
        set {
            self.contentInset.bottom = newValue
        }
    }
    
    var insetLeft: CGFloat {
        get {
            return self.contentInset.left
        }
        set {
            self.contentInset.left = newValue
        }
    }
    
    var insetRight: CGFloat {
        get {
            return self.contentInset.right
        }
        set {
            self.contentInset.right = newValue
        }
    }
    
    var contentOffsetX: CGFloat {
        get {
            return self.contentOffset.x
        }
        set {
            self.contentOffset.x = newValue
        }
    }
    
    var contentOffsetY: CGFloat {
        get {
            return self.contentOffset.y
        }
        set {
            self.contentOffset.y = newValue
        }
    }
    
    var contentW: CGFloat {
        get {
            return self.contentSize.width
        }
        set {
            self.contentSize.width = newValue
        }
    }
    
    var contentH: CGFloat {
        get {
            return self.contentSize.height
        }
        set {
            self.contentSize.height = newValue
        }
    }
    
}

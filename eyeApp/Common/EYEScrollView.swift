//
// EYEScrollView.swift
// eyeApp
//
// Create by 周涛 on 2018/11/8.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit

class EYEScrollView: UIScrollView, UIGestureRecognizerDelegate {
    static var fatherScrollView: UIScrollView?
    static var isFatherScrollEnable: Bool = true
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        /*if self.contentOffset.x <= 0 && self.contentOffset.x == 375{
            //UIConstant.forbidLeftScroll = true
    
        }*/
        
        //&& CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.contentSize.width, height: self.contentSize.height).contains(point)
        /*if self != EYEScrollView.fatherScrollView && EYEScrollView.isFatherScrollEnable &&  point.y <= self.height {
               // EYEScrollView.fatherScrollView?.isScrollEnabled = false
                EYEScrollView.isFatherScrollEnable = false
        } else if self == EYEScrollView.fatherScrollView && !EYEScrollView.isFatherScrollEnable {
            return self
        }*/
        if self != EYEScrollView.fatherScrollView && EYEScrollView.isFatherScrollEnable {
            EYEScrollView.isFatherScrollEnable = false
            EYEScrollView.fatherScrollView?.isScrollEnabled = false
        }
        
        return super.hitTest(point, with: event)
        /*let tmpFrame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.contentSize.width, height: self.contentSize.height)
        print( "\(tmpFrame.contains(point))    :   \(point)" )
        if tmpFrame.contains(point) {
            return self
        }
        return nil*/
        
    }
    
    /*
    override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        print("touchesShouldBegin")
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       print("touchesBegan")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touchesEnded")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touchesMoved")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }*/
}

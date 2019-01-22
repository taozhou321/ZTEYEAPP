//
// UIButton+EYE.swift
// eyeApp
//
// Create by 周涛 on 2018/10/26.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit
enum BtnImagePositionType {
    case Left //图片在文字左方
    case Right //图片在文字右方
    case Top //图片在文字上方
    case Buttom //图片在文字下方
}

/*
 如UIEdgeInsetsMake朝着top方向变化,top中的值为20，实际上相当于y值增加10（因为需要保证移动后size保存不变，所以bottom也需跟着移动，等效于top=10，buttom=-10），
 */
extension UIButton {
    func adjustPosition(btnImagePositionType: BtnImagePositionType, distance: CGFloat) {
        guard let imageWidth = self.imageView?.width,
            let imageHeight = self.imageView?.height,
            let labelWidth = self.titleLabel?.width,
            let labelHeight = self.titleLabel?.height
        else {return}
        
        switch btnImagePositionType {
        case .Left:
            self.titleEdgeInsets = UIEdgeInsetsMake(0, distance / 2, 0, -distance/2)
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -distance/2, 0, distance/2)
            break
        case .Right:
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - distance / 2, 0, imageWidth + distance/2)
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + distance/2, 0, -labelWidth - distance/2)
            break
        case .Top:
            self.titleEdgeInsets = UIEdgeInsetsMake((imageHeight + distance)/2, -(imageWidth)/2, -(imageHeight + distance)/2, imageWidth/2)
            self.imageEdgeInsets = UIEdgeInsetsMake(-(labelHeight + distance) / 2, labelWidth/2, (labelHeight+distance)/2, labelWidth/2)
            break
        case .Buttom:
            self.titleEdgeInsets = UIEdgeInsetsMake(-(imageHeight + distance)/2, -(imageWidth)/2, (imageHeight + distance)/2, imageWidth/2)
            self.imageEdgeInsets = UIEdgeInsetsMake((labelHeight + distance) / 2, labelWidth/2, -(labelHeight+distance)/2, labelWidth/2)
            break

        }
    }
}

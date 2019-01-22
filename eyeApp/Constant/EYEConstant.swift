//
// EyeConstant.swift
// eyeApp
//
// Create by 周涛 on 2018/10/8.
// Copyright © 2018年 周涛. All rights reserved.
// github: https://github.com/taozhou321


import UIKit

enum IconType {
    case round
}

struct UIConstant {
    static var forbidLeftScroll = false
    // 屏幕宽高
    static let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
    static let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height
    //状态栏高度
    static let STATUSBAR_HEIGHT: CGFloat = UIApplication.shared.statusBarFrame.height
    //顶部滚动视图高度
    static let HEAD_HEIGHT: CGFloat = 40
    //底部Tabbar高度
    static let TABBAR_HEIGHT: CGFloat = 49
    
    static let PLAYVIEW_H_W_IN_VERTICAL: CGFloat = 9.0 / 16.0 // 播放视图竖直方向上高宽
    
    // 字体
    static let UI_FONT_12 : CGFloat = 12
    static let UI_FONT_13 : CGFloat = 13
    static let UI_FONT_14 : CGFloat = 14
    static let UI_FONT_16 : CGFloat = 16
    static let UI_FONT_20 : CGFloat = 20
    
    static let UI_Font_bigBold: UIFont = UIFont(name: "DINCondenseBold.TTF", size: 20)!
    static let UI_Font_lobster: UIFont = UIFont(name: "Lobster 1.4.otf", size: 16)!
    
    // 间距
    static let UI_MARGIN_5 : CGFloat = 5
    static let UI_MARGIN_10 : CGFloat = 10
    static let UI_MARGIN_15 : CGFloat = 15
    static let UI_MARGIN_20 : CGFloat = 20

    static let UI_GRAY: UIColor = UIColor(red: 0xB6 / 255.0, green: 0xB6 / 255.0, blue: 0xB6 / 255.0, alpha: 1)
    static let UI_DARK: UIColor = UIColor(red: 0x33 / 255.0, green: 0x33 / 255.0, blue: 0x33 / 255.0, alpha: 1)
    
}

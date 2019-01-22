//
// String+EYE.swift
// eyeApp
//
// Create by 周涛 on 2019/1/16.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

import Foundation

extension String {
    func heightWithFont(font: UIFont, fixWidth: CGFloat) -> CGSize {
        let size = CGSize(width: fixWidth, height: CGFloat.infinity)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil)
        return rect.size
    }
}

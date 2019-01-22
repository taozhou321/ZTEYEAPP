//
// EYEBarView.swift
// eyeApp
//
// Create by 周涛 on 2019/1/13.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit

@IBDesignable class EYEBarView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var barView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EYEBarView", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        self.view.frame = bounds
        self.addSubview(self.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EYEBarView", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        self.view.frame = bounds
        self.addSubview(self.view)
    }
    
    /**
     value取值[0,1]
     */
    func setBarValue(value: CGFloat) {
        var tmpValue = value
        if tmpValue < 0 {
            tmpValue = 0
        }
        if tmpValue > 1 {
            tmpValue = 1
        }
        
        let h = self.height * tmpValue
        let y = self.height - h
        self.barView.frame = CGRect(x: 0, y: y, width: self.barView.width, height: h)
    }
}



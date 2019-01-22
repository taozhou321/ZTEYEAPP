//
// EYESliderView.swift
// eyeApp
//
// Create by 周涛 on 2019/1/13.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit
import MediaPlayer

/*class EYESliderView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var sliderView: UISlider!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EYESliderView", bundle: bundle)
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
    
}*/

class EYESliderView: MPVolumeView {
    
}

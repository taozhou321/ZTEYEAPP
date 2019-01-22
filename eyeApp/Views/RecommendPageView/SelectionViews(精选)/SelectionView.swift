//
// SelectionView.swift
// eyeApp
//
// Create by 周涛 on 2018/11/16.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import Foundation

//精选视图

class SelectionView: UIView {
    @IBOutlet weak var headTitle: UILabel!
    @IBOutlet weak var headSubTitle: UILabel!
    @IBOutlet weak var selectionScrollView: UIScrollView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        
    }
    
}

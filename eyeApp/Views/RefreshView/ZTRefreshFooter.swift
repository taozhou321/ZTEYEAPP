//
// ZTRefreshFooter.swift
// eyeApp
//
// Create by 周涛 on 2019/1/9.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit

class ZTRefreshFooter: ZTRefreshComponent {
    private var loadingView: EYELoadingPageView = EYELoadingPageView(frame: CGRect(x: 0, y: 0, width: 42, height: 28))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.loadingView)
        self.isAutoChangeAlpha = false
        self.loadingView.startLoadingAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(self.loadingView)
        self.isAutoChangeAlpha = false
        self.loadingView.startLoadingAnimation()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.y = self.scrollView.height
        self.loadingView.center = CGPoint(x: self.width / 2, y: self.height / 2 )
    }
    
    
    override var state: ZTRefreshState {
        didSet {
            //if self.state == oldValue {return}
            if self.state == .ZTRefreshStateIdle && oldValue == .ZTRefreshStateRefreshing {
                self.loadingView.stopLoadingAnimation()
               /* UIView.animate(withDuration: self.hideTimeInterval, animations: {
                    self.scrollView.insetBottom = self.scrollViewOriginalInset.bottom
                    
                }) { (finished) in
                    self.transform = CGAffineTransform.identity
                   
                }*/
            } else if self.state == .ZTRefreshStateRefreshing {
                //self.scrollView.insetBottom = self.height + self.scrollViewOriginalInset.bottom
                self.loadingView.startLoadingAnimation()
                //开始获取数据
                self.refreshDataDelegate?.refreshGetData()
                
                
            }
        }
    }
    
    
    override func scrollViewContentOffsetDidChange(change: Dictionary<NSKeyValueChangeKey, Any>?) {
        super.scrollViewContentOffsetDidChange(change: change)
        if change == nil {return}
        guard  let offset = (change![NSKeyValueChangeKey.newKey]) as? CGPoint else {return}
        let offsetY = offset.y
        /**发生偏移时的offsetY*/
        let happenOffsetY =  (self.scrollView.contentH + self.scrollViewOriginalInset.bottom) - self.scrollView.height
        let thresholdOffsetY = happenOffsetY  //判断状态改变的竖直方向上的阀值
        if happenOffsetY > offsetY {return}
        
        let pullingPercent = (offsetY - happenOffsetY) / self.height
        
        if self.scrollView.isDragging {
            self.pullingPercent = pullingPercent
            
            if self.state == .ZTRefreshStateIdle && thresholdOffsetY <=  offsetY {
                self.state = .ZTRefreshStatePulling
            } else if self.state == .ZTRefreshStatePulling && thresholdOffsetY > offsetY {
                self.state = .ZTRefreshStateIdle
            }
        } else if self.state == .ZTRefreshStatePulling {
            self.state = .ZTRefreshStateRefreshing
        }
 
 
        /*else if self.state == .ZTRefreshStateIdle && pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }*/
        
    }
    
    override func scrollViewContentSizeDidChange(change: Dictionary<NSKeyValueChangeKey, Any>?) {
        
        super.scrollViewContentSizeDidChange(change: change)
        if change == nil {return}
        guard  let contentSize = (change![NSKeyValueChangeKey.newKey]) as? CGSize else {return}
        self.y = contentSize.height
    }
    
    
}

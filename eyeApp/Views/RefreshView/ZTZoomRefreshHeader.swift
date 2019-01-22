//
// ZTZoomRefreshHeader.swift
// eyeApp
//
// Create by 周涛 on 2019/1/8.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit

class ZTZoomRefreshHeader: ZTRefreshComponent {
    
    private var loadingView: EYELoadingPageView = EYELoadingPageView(frame: CGRect(x: 0, y: 0, width: 42, height: 28))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.loadingView)
        self.isAutoChangeAlpha = true
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(self.loadingView)
        self.isAutoChangeAlpha = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.y = -self.height
        //self.y -= self.height // 在此处加入该句代码会导致zoom方法中的CGAffineTransform执行出现异常
        //真的😒， 应该是self.y = -self.height才对头，写错为self.y -= self.height ，每次调用layoutSubviews都会导致self.y = self.y - self.height
        self.loadingView.center = CGPoint(x: self.width / 2, y: self.height / 2 )
    }
    
    
    override var state: ZTRefreshState {
        didSet {
            if self.state == oldValue {return}
            if self.state == .ZTRefreshStateIdle && oldValue == .ZTRefreshStateRefreshing {
                self.loadingView.stopLoadingAnimation()
                UIView.animate(withDuration: self.hideTimeInterval, animations: {
                    self.scrollView.insetTop = self.scrollViewOriginalInset.top
                    
                }) { (finished) in
                    self.transform = CGAffineTransform.identity
                    self.pullingPercent = 0
                }
            } else if self.state == .ZTRefreshStateRefreshing {
                self.scrollView.insetTop = self.height + self.scrollViewOriginalInset.top
                self.loadingView.startLoadingAnimation()
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                    self.state = .ZTRefreshStateIdle
                }
            }
        }
    }
    
    
    override func scrollViewContentOffsetDidChange(change: Dictionary<NSKeyValueChangeKey, Any>?) {
        super.scrollViewContentOffsetDidChange(change: change)
        if change == nil {return}
        guard  let offset = (change![NSKeyValueChangeKey.newKey]) as? CGPoint else {return}
        let offsetY = offset.y
        /**发生偏移时的offsetY*/
        let happenOffsetY = -self.scrollViewOriginalInset.top
        let thresholdOffsetY = happenOffsetY - self.height //判断状态改变的竖直方向上的阀值
        if offsetY > happenOffsetY {return}
        let pullingPercent = (happenOffsetY - offsetY) / self.height
        
        if self.scrollView.isDragging {
            self.pullingPercent = pullingPercent
            if self.state == .ZTRefreshStateIdle {
                self.zoom(zoomPercent: self.pullingPercent)
            }
            if self.state == .ZTRefreshStateIdle && offsetY <=  thresholdOffsetY {
                self.state = .ZTRefreshStatePulling
            } else if self.state == .ZTRefreshStatePulling && thresholdOffsetY < offsetY {
                self.state = .ZTRefreshStateIdle
            }
        } else if self.state == .ZTRefreshStatePulling {
            self.state = .ZTRefreshStateRefreshing
        } else if self.state == .ZTRefreshStateIdle && pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    
    }
    
  /*  override func scrollViewPanStateDidChange(change: Dictionary<NSKeyValueChangeKey, Any>?) {
        super.scrollViewPanStateDidChange(change: change)
        if change == nil {return}
        guard  let newState = (change![NSKeyValueChangeKey.newKey]) as? UIGestureRecognizerState, let oldState = (change![NSKeyValueChangeKey.oldKey]) as? UIGestureRecognizerState else {return}
    }*/
    
    
    private func zoom(zoomPercent: CGFloat) {
        self.loadingView.transform = CGAffineTransform(scaleX: zoomPercent, y: zoomPercent ).concatenating(CGAffineTransform(translationX: 0, y: (1 - zoomPercent) * self.height / 2))
        
    }
    
    
}

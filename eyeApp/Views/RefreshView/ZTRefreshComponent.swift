//
// ZTRefreshComponent.swift
// eyeApp
//
// Create by 周涛 on 2019/1/8.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit

enum ZTRefreshState {
    /** 普通闲置状态 */
    case ZTRefreshStateIdle
    /** 松开就可以进行刷新的状态 */
    case ZTRefreshStatePulling
    /** 正在刷新中的状态 */
    case ZTRefreshStateRefreshing
    /** 所有数据加载完毕，没有更多的数据了 */
    case ZTRefreshStateNoMoreData
}

let ZTRefreshKeyPathContentOffset = "contentOffset"
let ZTRefreshKeyPathContentInset = "contentInset"
let ZTRefreshKeyPathContentSize = "contentSize"
let ZTRefreshKeyPathPanState = "state"

protocol RefreshGetDataDelegate: NSObjectProtocol {
    func refreshGetData()
}

class ZTRefreshComponent: UIView {
    weak var refreshDataDelegate: RefreshGetDataDelegate?
    
    var hideTimeInterval: TimeInterval = 0.3
    
    var scrollView: UIScrollView!
    var state: ZTRefreshState = .ZTRefreshStateIdle
    var isAutoChangeAlpha: Bool = false {
        didSet {
            if self.isAutoChangeAlpha {
                self.alpha = self.pullingPercent
            } else {
                self.alpha = 1
            }
        }
    }
    var isRefreshing: Bool {
        get {
            return self.state == .ZTRefreshStateRefreshing
        }
    }
    
    var scrollViewOriginalInset: UIEdgeInsets!
    
    var pullingPercent: CGFloat = 0 {
        didSet {
            if self.pullingPercent < 0 {
                self.pullingPercent = 0
            }
            if self.pullingPercent > 1 {
                self.pullingPercent = 1
            }
 
            if self.isAutoChangeAlpha {
                self.alpha = self.pullingPercent
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        guard let _scrollView = newSuperview as? UIScrollView else {return}
        
        self.removeObservers()
        
        self.scrollView = _scrollView
        self.scrollView.alwaysBounceVertical = true
       // self.isAutoChangeAlpha = true
        //self.alpha = 0
        self.scrollViewOriginalInset = self.scrollView.contentInset
        self.addObservers()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func addObservers() {
        let options = NSKeyValueObservingOptions.init(rawValue: NSKeyValueObservingOptions.new.rawValue | NSKeyValueObservingOptions.old.rawValue)
        self.scrollView.addObserver(self, forKeyPath: ZTRefreshKeyPathContentOffset, options: options, context: nil)
        self.scrollView.addObserver(self, forKeyPath: ZTRefreshKeyPathContentSize, options: options, context: nil)
       // self.scrollView.panGestureRecognizer.addObserver(self, forKeyPath: ZTRefreshKeyPathPanState, options: options, context: nil)
    }
    
    private func removeObservers() {
        if self.scrollView != nil {
            self.scrollView.removeObserver(self, forKeyPath: ZTRefreshKeyPathContentOffset)
            self.scrollView.removeObserver(self, forKeyPath: ZTRefreshKeyPathContentSize)
        
           // self.scrollView.panGestureRecognizer.removeObserver(self, forKeyPath: ZTRefreshKeyPathPanState)
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == ZTRefreshKeyPathContentOffset {
            self.scrollViewContentOffsetDidChange(change: change)
        }
        if keyPath == ZTRefreshKeyPathContentSize {
            self.scrollViewContentSizeDidChange(change: change)
        }
    }
    
    func scrollViewContentOffsetDidChange(change: Dictionary<NSKeyValueChangeKey, Any>?) {}
    func scrollViewContentSizeDidChange(change: Dictionary<NSKeyValueChangeKey, Any>?) {}
    func scrollViewPanStateDidChange(change: Dictionary<NSKeyValueChangeKey, Any>?) {}
}


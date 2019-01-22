//
// UIView+EYE.swift
// eyeApp
//
// Create by 周涛 on 2018/10/23.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit

/*class EYEErrorPageView: UIButton {
    //var errorImageView: UIImageView!
    var reloadButton: UIButton!
    var didClickReloadBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        errorImageView = UIImageView()
    }
}*/


extension UIView {
    
    
    /*var reloadAction: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &reloadActionKey) as? (() -> Void)
        }
        set {
            objc_setAssociatedObject(self, &reloadActionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
    }
    
    private var errorPageView: UIView {
        
        let tmpErrorPageView =  UIView(frame: self.bounds)
        let errorBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        errorBtn.imageView?.image = #imageLiteral(resourceName: "ic_loading_error")
        errorBtn.titleLabel?.text = "网络异常，请点击重试"
       
        
        tmpErrorPageView.addSubview(errorBtn)
        errorBtn.adjustPosition(btnImagePositionType: .Top, distance: 10)
        
        tmpErrorPageView.snp.makeConstraints { (make) in
            make.center.equalTo(tmpErrorPageView)
        }
        return tmpErrorPageView
    }
    */
    
    func showErrorPage(errorView: UIView) {
        self.addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        self.bringSubview(toFront: errorView)//将异常页面至于最前
    }
    
    func hideErrorPage(errorView: UIView) {
        if errorView.superview != nil {
            errorView.removeFromSuperview()
        }
    }
    
    func showLoadingPage(loadingView: EYELoadingPageView) {
        self.addSubview(loadingView)
        if self.center != loadingView.centerInSuperView {
            loadingView.snp.makeConstraints { (make) in
                /*
                 注: 若使用snapkit对控件位置进行设置,控件宽高也需在这里设置，
                 若未在此处设置宽高，打印此处loadingView显示frame = (166.5 319.5; 0 0)
                 */
                make.width.equalTo(42)
                make.height.equalTo(28)
                make.center.equalTo(self)
            }
        }
        loadingView.startLoadingAnimation()
        self.bringSubview(toFront: loadingView)
    }
    
    func hideLoadingPage(loadingView: EYELoadingPageView) {
        loadingView.stopLoadingAnimation()
        if loadingView.superview != nil {
            loadingView.removeFromSuperview()
        }
    }
    
}


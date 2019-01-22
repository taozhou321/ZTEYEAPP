//
// EYETabarTransition.swift
// eyeApp
//
// Create by 周涛 on 2018/10/12.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit

class EYETabbarTransition:NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.4
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {return}
        let fromView = fromVC.view
        let toView = toVC.view
        toView?.alpha = 0
        let containerView = transitionContext.containerView
        containerView.addSubview(toView!)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView?.alpha = 0
            toView?.alpha = 1
        }) { (_) in
            fromView?.alpha = 1
            transitionContext.completeTransition(true)
        }
    }
}

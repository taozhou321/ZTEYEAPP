//
// MainViewController.swift
// eyeApp
//
// Create by 周涛 on 2018/10/8.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit

class EYEMainViewController: UITabBarController {
    
    enum MainTabType:Int {
        case MainTabHomePage = 0 //首页
        case MainTabSubsciption //关注
        case MainTabNotification //通知
        case MainTabProfile //我的
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self

       
       /* // 添加launchView
        if launchView != nil {
            view.addSubview(launchView!)
        }
        // 动画完成回调
        launchView?.animationDidStop { [unowned self](launchView) in
            self.launchViewRemoveAnimation()
        }*/
    }
    
    override func viewDidLayoutSubviews() {
       
    }
    
    //MARK:- lazy
    private lazy var launchView: EYELaunchView? = {
        var launchView = EYELaunchView.launchView()
        launchView?.frame = self.view.frame
        return launchView
    }()
    
    //MARK:- private methods
    
    // 设置子控制器
    /*private func setupChildController() {
        guard let configs = vcInfoForTabType() else {return}
        var vcArrays = [UINavigationController]()
        for index in 0..<TabbarCount {
            guard let type = MainTabType(rawValue: index), let item = configs[type] else {continue}
            let vcName: String = item[TabbarVC]!
            let tabbarTitle: String = item[TabbarTitle]!
            let tabbarImage: String = item[TabbarImage]!
            let tabbarSelectedImage: String = item[TabbarSelectedImage]!
            //swift中自定义的类需要加上项目名
            guard let clazz = NSClassFromString("eyeApp." + vcName) else {continue}
            //let classType: UINavigationController.Type = clazz as! UINavigationController.Type
            let vc = clazz.alloc()
            let nvc: UINavigationController = UINavigationController(rootViewController: vc as! UIViewController)
            //let animator = NavigationDelegate()
            
            //nvc.delegate = animator //转场动画代理
            //self.navigationDelegate.append(animator)
            nvc.tabBarItem = UITabBarItem(title: tabbarTitle, image: UIImage(named: tabbarImage), selectedImage: UIImage(named: tabbarSelectedImage))
            vcArrays.append(nvc)
        }
        self.viewControllers = vcArrays
    }*/
    
    
    private func launchViewRemoveAnimation() {
        if self.launchView == nil {return}
        UIView.animate(withDuration: 1, animations: {
            self.launchView!.alpha = 0
        }) { [unowned self](_) in
            self.launchView?.removeFromSuperview()
        }
    }
    
    
   /* private func vcInfoForTabType() -> Dictionary<MainTabType, Dictionary<String,String>>? {
        if TabbarCount == 0 {return nil}
        let configs = [MainTabType.MainTabHomePage: [
            TabbarVC: "EYEHomePageController",
            TabbarTitle: "首页",
            TabbarImage: "AllDevice",
            TabbarSelectedImage: "AllDevice_Selected"
            ],
                       MainTabType.MainTabSubsciption: [
                        TabbarVC: "EYEComunityController",
                        TabbarTitle: "关注",
                        TabbarImage: "GroupDevice",
                        TabbarSelectedImage: "GroupDevice_Selected"
            ],
                       MainTabType.MainTabNotification: [
                        TabbarVC: "EYENotificationController",
                        TabbarTitle: "通知",
                        TabbarImage: "TimingTask",
                        TabbarSelectedImage: "TimgingTask_Selected"
            ],
                       MainTabType.MainTabProfile: [
                        TabbarVC: "EYEProfileController",
                        TabbarTitle: "我的",
                        TabbarImage: "Remote",
                        TabbarSelectedImage: "Remote"
            ]]
        return configs
    }*/
    
}

extension EYEMainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return EYETabbarTransition()
    }
}

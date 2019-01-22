//
// UIViewController+Swizzling.swift
// eyeApp
//
// Create by 周涛 on 2018/10/8.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit
/*
 ObjC runtime的原理，ObjC使用Messaging策略——选择器向接收器发送消息，编译阶段无法得知接收器对象或类是否有对应的方法，仅将自定义的面向对象类型编译生成对应的运行时类型，即大量C结构体和C函数。程序运行时阶段，运行时系统根据对象的isa指针找到对象所属的类结构体，然后通过结合类中的缓存方法列表指针和虚函数表指针进行查找选择器对应的SEL选择器类型变量，如果找到则根据SEL变量对应的IMP指针找到方法实现。若找不到对应的方法，则会启动消息转发机制，如果仍然失败，则抛出运行时异常。
 
 Swift代码中已经没有了Objective-C的运行时消息机制, 在代码编译时即确定了其实际调用的方法. 所以纯粹的Swift类和对象没有办法使用runtime, 更不存在method swizzling.
 为了兼容Objective-C, 凡是继承NSObject的类都会保留其动态性, 依然遵循Objective-C的运行时消息机制, 因此可以通过runtime获取其属性和方法, 实现method swizzling.
 
 */
extension UIViewController {
    
    static func SwizzlingUIViewControllerIMP() {
        swizzling_exchangeMethod(originalSelector: #selector(UIViewController.viewDidLoad), swizzlingSelector: #selector(UIViewController.swizzling_viewDidLoad))
        
    }

    
    static private func swizzling_exchangeMethod(originalSelector: Selector, swizzlingSelector: Selector) {
        
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector), let swizzlingMethod = class_getInstanceMethod(UIViewController.self, swizzlingSelector) else {
            return
        }
        let didAddMethod = class_addMethod(UIViewController.self, originalSelector, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod))
        if didAddMethod {
            class_replaceMethod(UIViewController.self, swizzlingSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzlingMethod)
        }
    }
    
    //MARK:- viewDidLoad
    //若不加objc class_getInstanceMethod返回空
    @objc func swizzling_viewDidLoad() {
        self.view.backgroundColor = UIColor.red
    }
    
    //MARK:- viewWillAppear
    func swizzling_viewWillAppear(animated: Bool) {
        
    }
    
    //MARK:- viewDidAppear
    func swizzling_viewDidAppear(animated: Bool) {
        
    }
    
    //MARK:- viewWillDisAppear()
    func swizzling_viewWillDisAppear(animated: Bool) {
        
    }
    
    //MARK:- viewDidDisAppear()
    func swizzling_viewDidDisAppear(animated: Bool) {
        
    }
}

/*override public class func load() {
    
}
 报错: Method 'load()' defines Objective-C class method 'load', which is not permitted by Swift
 原因及解决办法:
 Unfortunately, a load class method implemented in Swift is never called by the runtime, rendering that recommendation an impossibility. Instead, we're left to pick among second-choice options:
 
 Implement method swizzling in initialize. This can be done safely, so long as you check the type at execution time and wrap the swizzling in dispatch_once (which you should be doing anyway). swift 3 后initialize也不能使用
 Implement method swizzling in the app delegate. Instead of adding method swizzling via a class extension, simply add a method to the app delegate to be executed when application(_:didFinishLaunchingWithOptions:) is called. Depending on the classes you're modifying, this may be sufficient and should guarantee your code is executed every time.
 */


/*更类似于dispatch_once的方法
https://stackoverflow.com/questions/42824541/swift-3-1-deprecates-initialize-how-can-i-achieve-the-same-thing
 
 A common app entry point is an application delegate's applicationDidFinishLaunching. We could simply add a static function to each class that we want to notify on initialization, and call it from here.
 
 This first solution is simple and easy to understand. For most cases, this is what I'd recommend. Although the next solution provides results that are more similar to the original initialize() function, it also results in slightly longer app start up times. I no longer think it is worth the effort, performance degradation, or code complexity in most cases. Simple code is good code.
 
 Read on for another option. You may have reason to need it (or perhaps parts of it)
 */

/*extension UIApplication {
 private static let runOnce: Void = {
 UIViewController.SwizzlingUIViewControllerIMP()
 }()
 
 open override var next: UIResponder? {
 // Called before applicationDidFinishLaunching
 UIApplication.runOnce
 return super.next
 }
 }*/


/*
 在Swift中，Void类型其实是一个别名类型，而其真正的类型为()，即一个空元祖（empty tuple）！
 
 这种语言特性给Swift带来了一些比较方便的表达方式。当()作为函数返回类型时，它作为一个类型；当它作为一个表达式时，则表示一个空元祖。这样，我们在返回类型为()（或Void）的Swift函数中可以，最后返回一个不干任何事的空元祖，这在三目表达式中尤为有用。
 如:
 var sss = 0
 
 func MyFunc() -> () {
 return sss == 0 ? (sss = 100) : ()
 }
 
 func MyFunc2() -> Void {
 return sss > 0 ? sss += 100 : (sss += 0)
 }
 */

    


//
// GlobalFunc.swift
// eyeApp
//
// Create by 周涛 on 2018/10/9.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

func ZTLog<T>(_ message: T, funcName:String = #function, line: Int = #line) {
    #if DEBUG
    print("\(funcName) \(line): \(message)")
    #endif
}

func ZTRandomColor() -> UIColor {
    let r: CGFloat = CGFloat(arc4random()%255) / (255.0)
    let g: CGFloat = CGFloat(arc4random()%255) / 255.0
    let b: CGFloat = CGFloat(arc4random()%255) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: 1)
}

func checkNetConnect() {
    guard let reachAbility = Reachability()?.connection else {return}
    switch reachAbility {
    case .cellular:break
        
    default:break
        
    }
    
}

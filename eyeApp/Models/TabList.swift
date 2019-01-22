//
// TabList.swift
// eyeApp
//
// Create by 周涛 on 2018/10/22.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import Foundation

//列表模型
struct EYETabListModel {
    /*
     id 值表示类型
     -1: 发现
     -2: 推荐
     -3: 日报
     -4: 社区 //未显示
     14: 广告
     36: 生活
     10: 动画
     28: 搞笑
     4: 开胃
     2: 创意
     18: 运动
     20: 音乐
     26: 萌宠
     12: 剧情
     32: 科技
     6: 旅行
     8: 影视
     22: 记录
     30: 游戏
     38: 综艺
     24: 时尚
     34: 集锦//未显示
     */
    var id: Int!
    var title: String! //顶部标签名
    var apiUrlStr: String!
    var tabTye: Int!
    var nameType: Int!
    var adTrack: Any?
    
    init(dict: NSDictionary) {
        self.id = dict["id"] as? Int ?? 0
        self.title = dict["name"] as? String ?? "nil"
        self.apiUrlStr = dict["apiUrl"] as? String ?? "nil"
        self.tabTye = dict["tabTyoe"] as? Int ?? 0
        self.nameType = dict["nameType"] as? Int ?? 0
        self.adTrack = dict["adTrack"]
    }
    
}

//
// TextCardModel.swift
// eyeApp
//
// Create by 周涛 on 2018/10/31.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321
import SwiftyJSON
struct TextCardModel {
    static let type = "textCard"
    var data: TextCardData
    var tag: DataTag?
    var id: Int?
    var adIndex: Int?
    
    init(dict: Dictionary<String, JSON>) {
        self.id = dict["id"]?.intValue
        self.data = TextCardData(dict: (dict["data"]!.dictionaryValue))
        self.tag = DataTag(dict: dict["tag"]?.dictionaryValue)
        self.adIndex = dict["adIndex"]?.intValue
    }
}

struct TextCardData {
    static let dataType = "TextCard"
    var id: Int?
    var type: String?
    var text: String?
    var subTitle: String?
    var actionUrl: String?
    var adTrack: Any?
    var follow: DataFollow?
    
    init(dict: Dictionary<String, JSON>) {
        self.id = dict["id"]?.intValue
        self.type = dict["type"]?.stringValue
        self.text = dict["text"]?.stringValue
        self.subTitle = dict["subTitle"]?.stringValue
        self.actionUrl = dict["actionUrl"]?.stringValue
        self.adTrack = dict["adTrack"]
        self.follow = DataFollow(dict: dict["follow"]?.dictionaryValue)
    }
}

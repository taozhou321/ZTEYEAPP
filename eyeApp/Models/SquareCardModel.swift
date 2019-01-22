//
// SquareCardModel.swift
// eyeApp
//
// Create by 周涛 on 2018/10/30.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import SwiftyJSON

struct SquareCardModel {
    static let type = "squareCardCollection"
    var data: SquareCardData
    var tag: DataTag?
    var id: Int?
    var adIndex: Int?
    init(dict: Dictionary<String, JSON>) {
        self.id = dict["id"]?.intValue
        self.data = SquareCardData(dict: (dict["data"]!.dictionaryValue))
        let tmpDataTag = dict["tag"]?.dictionaryValue
        if tmpDataTag != nil {
            self.tag = DataTag(dict: tmpDataTag!)
        }
        self.adIndex = dict["adIndex"]?.intValue
        
    }
}

struct SquareCardData {
    static let dataType = "ItemCollection"
    var header: SquareCardDataHeader
    var itemList: [FollowCardModel]?
    var count: Int?
    var adTrack: Any?
    init(dict: Dictionary<String, JSON>) {
        self.header = SquareCardDataHeader(dict: dict["header"]!.dictionaryValue)
        let tmpItemList = dict["itemList"]?.arrayValue
        if tmpItemList != nil {
            self.itemList = [FollowCardModel]()
            for item in tmpItemList! {
                self.itemList?.append(FollowCardModel(dict: item.dictionaryValue))
            }
        }
        self.count = dict["count"]?.intValue
        self.adTrack = dict["adTrack"]
    }
    
}

struct SquareCardDataHeader {
    
    var id: Int!
    var title: String! //开眼编辑精选
    var font: String? //bigBold
    var subTitle: String? //显示时间
    var subTitleFont: String?
    var textAlign: String?
    var cover: DataCover?
    var label: DataLabel?
    var actionUrl: String!
    var labelList: [DataLabel]?
    var rightText: String?
    init(dict: Dictionary<String, JSON>) {
        self.id = dict["id"]?.intValue
        self.title = dict["title"]?.stringValue
        self.font = dict["font"]?.stringValue
        self.subTitle = dict["subTitle"]?.stringValue
        self.subTitleFont = dict["subTitleFont"]?.stringValue
        self.textAlign = dict["textAlign"]?.stringValue
        let tmpDataCover = dict["cover"]?.dictionaryValue
        if tmpDataCover != nil {
            self.cover = DataCover(dict: tmpDataCover!)
        }
        let tmpDataLabel = dict["label"]?.dictionaryValue
        if tmpDataLabel != nil {
            self.label = DataLabel(dict: tmpDataLabel!)
        }
        self.actionUrl = dict["actionUrl"]?.stringValue
        let tmpDataLabelArray = dict["labelList"]?.arrayValue
        if tmpDataLabelArray != nil {
            self.labelList = [DataLabel]()
            for item in tmpDataLabelArray! {
                guard let tmpDataLabel = DataLabel(dict: item.dictionaryValue) else {continue}
                self.labelList?.append(tmpDataLabel)
            }
        }
        
        self.rightText = dict["rightText"]?.stringValue
        
    }
}




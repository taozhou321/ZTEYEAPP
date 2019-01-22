//
// BannerModel.swift
// eyeApp
//
// Create by 周涛 on 2018/10/31.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321
import SwiftyJSON
struct BannerModel {
    static let type = "banner"
    var data: BannerData
    var tag: DataTag?
    var id: Int?
    var adIndex: Int?
    init(dict: Dictionary<String, JSON>) {
        self.id = dict["id"]?.intValue
        self.data = BannerData(dict: (dict["data"]!.dictionaryValue))
        
        self.tag = DataTag(dict: dict["tag"]?.dictionaryValue)
        self.adIndex = dict["adIndex"]?.intValue
    }
}

struct BannerData {
    static let dataType = "Banner"
    var id: Int?
    var title: String?
    var description: String?
    var image: String?
    var actionUrl: String?
    var adTrack: Any?
    var shade: Bool
    var label: DataLabel?
    var labelList: [DataLabel]?
    var header: BannerDataHeader?
    
    init(dict: Dictionary<String, JSON>) {
        self.id = dict["id"]?.intValue
        self.title = dict["title"]?.stringValue
        self.description = dict["description"]?.stringValue
        self.image = dict["image"]?.stringValue
        self.actionUrl = dict["actionUrl"]?.stringValue
        self.adTrack = dict["adTrack"]
        self.shade = dict["shade"]!.boolValue
        
        self.label = DataLabel(dict: dict["label"]?.dictionaryValue)
        
        let tmpDataLabelArray = dict["label"]?.arrayValue
        if tmpDataLabelArray != nil {
            self.labelList = [DataLabel]()
            for item in tmpDataLabelArray! {
                guard let tmpDataLabel = DataLabel(dict: item.dictionaryValue) else {continue}
                self.labelList?.append(tmpDataLabel)
            }
        }
        
        self.header = BannerDataHeader(dict: dict["header"]!.dictionaryValue)
    }
}

struct BannerDataHeader {
    var id: Int?
    var title: String?
    var font: String?
    var subTitle: String?
    var subTitleFont: String?
    var textAlign: String?
    var cover: DataCover?
    var label: String?
    var actionUrl: String?
    var labelList: String?
    var rightText: String?
    var icon: String?
    var description: String?
    
    init(dict: Dictionary<String, JSON>) {
        self.id = dict["id"]?.intValue
        self.title = dict["title"]?.stringValue
        self.font = dict["font"]?.stringValue
        self.subTitle = dict["subTitle"]?.stringValue
        self.subTitleFont = dict["subTitleFont"]?.stringValue
        self.textAlign = dict["textAlign"]?.stringValue
        self.cover = DataCover(dict: dict["cover"]?.dictionaryValue)
        
        self.label = dict["label"]?.stringValue
        self.actionUrl = dict["actionUrl"]?.stringValue
        self.labelList = dict["labelList"]?.stringValue
        self.rightText = dict["rightText"]?.stringValue
        self.icon = dict["icon"]?.stringValue
        self.description = dict["description"]?.stringValue
    }
}



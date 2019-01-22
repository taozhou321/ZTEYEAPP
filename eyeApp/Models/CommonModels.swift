//
// CommonModels.swift
// eyeApp
//
// Create by 周涛 on 2018/11/1.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

//Data中公用的子模型
import SwiftyJSON

struct DataTag {
    var id: Int!
    var name: String!
    var actonUrl: String!
    var adTrack: Any?
    var desc: Any?
    var bgPicture: String?
    var headerImage: String?
    var tagRecType: String?
    var childTagList: Any?
    var childTagIdList: Any?
    var communityIndex: Int?
    
    init?(dict: Dictionary<String, JSON>?) {
        if dict == nil {return nil}
        
        self.id = dict!["id"]?.intValue
        self.name = dict!["name"]?.stringValue
        self.actonUrl = dict!["actionUrl"]?.stringValue
        self.adTrack = dict!["adTrack"]
        
        self.desc = dict!["desc"]
        self.bgPicture = dict!["bgPicture"]?.stringValue
        self.headerImage = dict!["headerImage"]?.stringValue
        self.tagRecType = dict!["tagRecType"]?.stringValue
        self.childTagList = dict!["childTagList"]
        self.childTagIdList = dict!["childTagIdList"]
        self.communityIndex = dict!["communityIndex"]?.intValue
    }
}

struct DataConsumption {
    var collectionCount: Int! //收藏数
    var shareCount: Int! //分享数
    var replyCount: Int! //回复，评论数
    init?(dict: Dictionary<String, JSON>?) {
        if dict == nil {return nil}
        self.collectionCount = dict!["collectionCount"]?.intValue
        self.shareCount = dict!["shareCount"]?.intValue
        self.replyCount = dict!["replyCount"]?.intValue
    }
}

struct DataProvider {
    var name: String?
    var alias: String?
    var icon: String?
    init?(dict: Dictionary<String, JSON>?) {
        if dict == nil {return nil}
        self.name = dict!["name"]?.stringValue
        self.icon = dict!["icon"]?.stringValue
        self.alias = dict!["alias"]?.stringValue
    }
}


struct DataAuthor {
    var id: Int!
    var icon: String!
    var name: String!
    var description: String!
    var link: String?
    var latestReleaseTime: CUnsignedLongLong?
    var videoNum: Int!
    var adTrack: Any?
    var follow: DataFollow!
    var shield: DataShield!
    var approvedNotReadyVideoCount: Int!
    var ifPgc: Bool!
    init?(dict: Dictionary<String, JSON>?) {
        if dict == nil {return nil}
        self.id = dict!["id"]?.intValue
        self.icon = dict!["icon"]?.stringValue
        self.name = dict!["name"]?.stringValue
        self.description = dict!["description"]?.stringValue
        self.link = dict!["link"]?.stringValue
        self.latestReleaseTime = dict!["latestReleaseTime"]?.uInt64Value
        self.videoNum = dict!["videoNum"]?.intValue
        self.adTrack = dict!["adTrack"]
        let followDict = dict!["follow"]?.dictionaryValue
        if followDict != nil {
            //let dataFollow = followDict[]
            self.follow = DataFollow(dict: followDict!)
        }
        
        let shieldDict = dict!["shield"]?.dictionaryValue
        if shieldDict != nil {
            self.shield = DataShield(dict: shieldDict!)
        }
        
        self.approvedNotReadyVideoCount = dict!["approvedNotReadyVideoCount"]?.intValue
        self.ifPgc = dict!["ifPgc"]!.boolValue
    }
}

struct DataFollow {
    var itemType: String!
    var itemId: Int!
    var followed: Bool?
    init?(dict: Dictionary<String, JSON>?) {
        if dict == nil {return nil}
        self.itemId = dict!["itemId"]?.intValue
        self.itemType = dict!["itemType"]?.stringValue
        self.followed = dict!["followed"]?.boolValue
    }
}

struct DataShield {
    var itemType: String!
    var itemId: Int!
    var shielded: Bool
    init?(dict: Dictionary<String, JSON>?) {
        if dict == nil {return nil}
        self.itemId = dict!["itemId"]?.intValue
        self.itemType = dict!["itemType"]?.stringValue
        self.shielded = dict!["shielded"]!.boolValue
    }
}

struct DataCover {
    var feed: String!
    var detail: String!
    var blurred: String!
    var sharing: Any?
    var homePage: String!
    init?(dict: Dictionary<String, JSON>?) {
        if dict == nil {return nil}
        self.feed = dict!["feed"]?.stringValue
        self.detail = dict!["detail"]?.stringValue
        self.blurred = dict!["blurred"]?.stringValue
        self.sharing = dict!["sharing"]
        self.homePage = dict!["homePage"]?.stringValue
    }
}

struct DataWebUrl {
    var raw: String!
    var forWeibo: String!
    init?(dict: Dictionary<String, JSON>?) {
        if dict == nil {return nil}
        self.raw = dict!["raw"]?.stringValue
        self.forWeibo = dict!["forWeibo"]?.stringValue
    }
}

struct DataPlayInfo {
    var height: Int
    var width: Int
    var urlList: [DataPlayInfoUrlList]?
    var name: String
    var type: String
    var url: String
    init?(dict: Dictionary<String, JSON>?) {
        if dict == nil {return nil}
        self.height = dict!["height"]!.intValue
        self.width = dict!["width"]!.intValue
        let tmpUrlListArray = dict!["urlList"]?.arrayValue
        if tmpUrlListArray != nil {
            self.urlList = [DataPlayInfoUrlList]()
            for item in tmpUrlListArray! {
                self.urlList!.append(DataPlayInfoUrlList(dict: item.dictionaryValue))
            }
        }
        self.name = dict!["name"]!.stringValue
        self.type = dict!["type"]!.stringValue
        self.url = dict!["url"]!.stringValue
    }
}

struct DataPlayInfoUrlList {
    var name: String
    var url: String
    var size: Int
    init(dict: Dictionary<String, JSON>) {
        //if dict == nil {return nil}
        self.name = dict["name"]!.stringValue
        self.url = dict["url"]!.stringValue
        self.size = dict["size"]!.intValue
    }
}

struct DataLabel {
    var text: String?
    var card: String?
    var detail: String?
    init?(dict: Dictionary<String, JSON>?) {
        if dict == nil {return nil}
        self.text = dict!["text"]?.stringValue
        self.card = dict!["card"]?.stringValue
        self.detail = dict!["detail"]?.stringValue
    }
}

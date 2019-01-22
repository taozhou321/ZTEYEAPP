//
// FollowCardModel.swift
// eyeApp
//
// Create by 周涛 on 2018/10/31.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

//----------------- FollowCard -----------------
import SwiftyJSON

struct FollowCardModel {
    static let type = "followCard"
    
    var data: FollowCardData
    var tag: DataTag?
    var id: Int?
    var adIndex: Int?
    
    init(dict: Dictionary<String, JSON>) {
        self.id = dict["id"]?.intValue
        self.data = FollowCardData(dict: (dict["data"]!.dictionaryValue))
        self.tag = DataTag(dict: dict["tag"]?.dictionaryValue)
        self.adIndex = dict["adIndex"]?.intValue
    }
    
}

struct FollowCardData {
    static let dataType = "FollowCard"
    var header: FollowCardDataHeader
    var content: FollowCardDataContent
    var adTrack: Any?
    init(dict: Dictionary<String, JSON>) {
        self.header = FollowCardDataHeader(dict: dict["header"]!.dictionaryValue)
        self.content = FollowCardDataContent(dict: dict["content"]!.dictionaryValue)
        self.adTrack = dict["adTrack"]
    }
}

struct FollowCardDataHeader {
   
    var id: Int!
    var title: String!
    var font: String?
    var subTitle: String?
    var subTitleFont: String?
    var textAlign: String?
    var cover: DataCover?
    var label: DataLabel?
    var actionUrl: String!
    var labelList: [DataLabel]?
    var rightText: String?
    var icon: String!
    var iconType: String!
    var description: String!
    var time: CUnsignedLongLong
    var showHateVideo: Bool!
    
    init(dict: Dictionary<String, JSON>) {
        self.id = dict["id"]?.intValue
        self.title = dict["title"]?.stringValue
        self.font = dict["font"]?.stringValue
        self.subTitle = dict["subTitle"]?.stringValue
        self.subTitleFont = dict["subTitleFont"]?.stringValue
        self.textAlign = dict["textAlign"]?.stringValue
        
        self.cover = DataCover(dict: dict["cover"]?.dictionaryValue)
        self.label = DataLabel(dict: dict["label"]?.dictionaryValue)
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
        self.icon = dict["icon"]?.stringValue
        self.iconType = dict["iconType"]?.stringValue
        self.description = dict["description"]?.stringValue
        self.time = dict["time"]!.uInt64Value
        self.showHateVideo = dict["showHateVideo"]!.boolValue
    }
}

struct FollowCardDataContent {
    static let type = "video"
    var data: FollowCardDataContentData
    var tag: DataTag?
    var id: Int?
    var adIndex: Int?
    
    init(dict: Dictionary<String, JSON>) {
        self.id = dict["id"]?.int
        self.data = FollowCardDataContentData(dict: (dict["data"]!.dictionaryValue))
        /*let tmpDataTag = dict["tag"] as? NSDictionary
        if tmpDataTag != nil {
            self.tag = DataTag(dict: tmpDataTag!)
        }*/
        self.tag = DataTag(dict: dict["tag"]?.dictionaryValue)
        self.adIndex = dict["adIndex"]?.intValue
    }
}

struct FollowCardDataContentData {
    static let dataType = "VideoBeanForClient"
    var id: Int?
    var title: String?
    var description: String?
    var library: String?
    var tags: [DataTag]?
    var consumption: DataConsumption!
    var resourceType: String?
    var slogan: String? //标语
    var provider: DataProvider?
    var category: String?
    var author: DataAuthor?
    var cover: DataCover?
    var playUrl: String?
    var thumbPlayUrl: String?
    var duration: Int
    var webUrl: DataWebUrl?
    var releaseTime: CUnsignedLongLong?
    var playInfo: [DataPlayInfoUrlList]?
    var campaign: Any?
    var waterMarks: Any?
    var ad: Bool?
    var adTrack: Any?
    var type: String?
    var titlePgc: String?
    var descriptionPgc: String?
    var remark: Any?
    var ifLimitVideo: Bool?
    var searchWeight: Int?
    var idx: Int?
    var shareAdTrack: Any?
    var favoriteAdTrack: Any?
    var webAdTrack: Any?
    var date: CUnsignedLongLong?
    var promotion: Any?
    var label: Any?
    var labelList: Any?
    var descriptionEditor: String?
    var collected: Bool?
    var played: Bool?
    var subtitles: [String]?
    var lastViewTime: Any?
    var playlists: Any?
    var src: Any?
    
    init(dict: Dictionary<String, JSON>) {
        self.id = dict["id"]?.intValue
        self.title = dict["title"]?.stringValue
        self.description = dict["description"]?.stringValue
        self.library = dict["library"]?.stringValue
        let tmpDataTagArray = dict["tags"]?.arrayValue
        if tmpDataTagArray != nil {
            self.tags = [DataTag]()
            for item in tmpDataTagArray! {
                guard let tmpDataTag = DataTag(dict:  item.dictionaryValue) else {continue}
                
                self.tags!.append(tmpDataTag)
            }
        }
        /*let tmpConsumption = dict["consumption"] as? NSDictionary
        if tmpConsumption != nil {
            self.consumption = DataConsumption(dict: tmpConsumption!)
        }*/
        self.consumption = DataConsumption(dict: dict["consumption"]?.dictionaryValue)
        
        self.resourceType = dict["resourceType"]?.stringValue
        self.slogan = dict["slogan"]?.stringValue
        /*let tmpDataProvider = dict["provider"] as? Dictionary<String, String>
        if tmpDataProvider != nil {
            self.provider = DataProvider(dict: tmpDataProvider!)
        }*/
        self.provider = DataProvider(dict: dict["provider"]?.dictionaryValue)
        
        self.category = dict["category"]?.stringValue
        
        /*let tmpDataAuthor = dict["author"] as? NSDictionary
        if tmpDataAuthor != nil {
            self.author = DataAuthor(dict: tmpDataAuthor!)
        }*/
        self.author = DataAuthor(dict: dict["author"]?.dictionaryValue)
        
        /*let tmpDataCover = dict["cover"] as? NSDictionary
        if tmpDataCover != nil {
            self.cover = DataCover(dict: tmpDataCover!)
        }*/
        self.cover = DataCover(dict: dict["cover"]?.dictionaryValue)
        
        self.playUrl = dict["playUrl"]?.stringValue
        
        self.thumbPlayUrl = dict["thumbPlayUrl"]?.stringValue
        self.duration = dict["duration"]!.intValue
        
        /*let tmpWebUrl = dict["webUrl"] as? Dictionary<String, String>
        if tmpWebUrl != nil {
            self.webUrl = DataWebUrl(dict: tmpWebUrl!)
        }*/
        self.webUrl = DataWebUrl(dict: dict["webUrl"]?.dictionaryValue)
        
        
        self.releaseTime = dict["releaseTime"]?.uInt64Value
        
        let tmpPlayInfo = dict["palyInfo"]?.arrayValue
        if tmpPlayInfo != nil {
            self.playInfo = [DataPlayInfoUrlList]()
            for item in tmpPlayInfo! {
                self.playInfo!.append(DataPlayInfoUrlList(dict: item.dictionaryValue))
            }
        }
        
        self.campaign = dict["campaign"]
        self.webAdTrack = dict["webAdTrack"]
        self.ad = dict["ad"]?.boolValue
        self.type = dict["type"]?.stringValue
        self.titlePgc = dict["titlePgc"]?.stringValue
        self.descriptionPgc = dict["descriptionPgc"]?.stringValue
        self.remark = dict["remark"]
        self.ifLimitVideo = dict["ifLimitVideo"]?.boolValue
        self.searchWeight = dict["searchWeight"]?.intValue
        self.idx = dict["idx"]?.intValue
        self.shareAdTrack = dict["shareAdTrack"]
        self.favoriteAdTrack = dict["favoriteAdTrack"]
        self.date = dict["date"]?.uInt64Value
        self.promotion = dict["promotion"]
        self.label = dict["label"]
        self.labelList = dict["labelList"]
        self.descriptionEditor =  dict["descriptionEditor"]?.stringValue
        self.collected = dict["collected"]?.boolValue
        self.played = dict["played"]?.boolValue
        self.subtitles = dict["subtitles"]?.arrayValue.map({ return $0.stringValue
        })
        self.lastViewTime = dict["lastViewTIme"]
        self.playlists = dict["playlists"]
        self.src = dict["src"]?.intValue
    }
}

/*
struct FollowCardDataContentDataTag {
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
    var communityIndex: Int!
    
    init(dict: NSDictionary) {
        
    }
}

struct FollowCardDataContentDataConsumption {
    var collectionCount: Int! //收藏数
    var shareCount: Int! //分享数
    var replyCount: Int! //回复，评论数
}

struct FollowCardDataContentDataProvider {
    var name: String?
    var alias: String?
    var icon: String?
}


struct FollowCardDataContentDataAuthor {
    var id: Int!
    var icon: String!
    var name: String!
    var description: String!
    var link: String?
    var latestReleaseTime: CUnsignedLongLong
    var videoNum: Int!
    var adTrack: Any?
    var follow: FollowCardDataContentDataAuthorFollow!
    var shield: FollowCardDataContentDataAuthorShield!
    var approvedNotReadyVideoCount: Int!
    var ifPgc: Bool!
}

struct FollowCardDataContentDataAuthorFollow {
    var itemType: String!
    var itemId: Int!
    var followed: Bool
}

struct FollowCardDataContentDataAuthorShield {
    var itemType: String!
    var itemId: Int!
    var shielded: Bool
}

struct FollowCardDataContentDataCover {
    var feed: String!
    var detail: String!
    var blurred: String!
    var sharing: Any?
    var homePage: String!
}

struct FollowCardDataContentDataWebUrl {
    var raw: String!
    var forWeibo: String!
}*/



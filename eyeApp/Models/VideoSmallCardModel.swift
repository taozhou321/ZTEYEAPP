//
// VideoSmallCardModel.swift
// eyeApp
//
// Create by 周涛 on 2018/10/31.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321
import SwiftyJSON
struct VideoSmallCardModel {
    static let type = "videoSmallCard"
    var data: VideoSmallCardData
    var tag: DataTag?
    var id: Int?
    var adIndex: Int?
    
    init(dict: Dictionary<String, JSON>) {
        self.data = VideoSmallCardData(dict: dict["data"]!.dictionaryValue)
        self.id = dict["id"]?.intValue
        self.adIndex = dict["adIndex"]?.intValue
        self.tag = DataTag(dict: dict["tag"]?.dictionaryValue) 
    }
    
}

struct VideoSmallCardData {
    static let dataType = "VideoBeanForClient"
    var id: Int?
    var title: String?
    var description: String?
    var library: String?
    var tags: [DataTag]!
    var consumption: DataConsumption!
    var resourceType: String?
    var slogan: String?
    var provider: DataProvider!
    var category: String?
    var author: DataAuthor!
    var cover: DataCover!
    var playUrl: String?
    var thumbPlayUrl: Any?
    var duration: Int
    var webUrl: DataWebUrl!
    var releaseTime: CUnsignedLongLong
    var playInfo: [DataPlayInfoUrlList]!
    var campaign: Any?
    var waterMarks: Any?
    var ad: Bool
    var adTrack: Any?
    var type: String?
    var titlePgc: Any?
    var descriptionPgc: Any?
    var remark: Any?
    var ifLimitVideo: Any?
    var searchWeight: Int?
    var idx: Int?
    var shareAdTrack: Any?
    var favoriteAdTrack: Any?
    var webAdTrack: Any?
    var date: CUnsignedLongLong
    var promotion: Any?
    var label: Any?
    var labelList: Any?
    var descriptionEditor: String?
    var collected: Bool
    var played: Bool
    var subtitles: Any?
    var lastViewTime: Any?
    var playlists: Any?
    var src: Int?
    
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
        
        
        self.releaseTime = dict["releaseTime"]!.uInt64Value
        
        let tmpPlayInfo = dict["palyInfo"]?.arrayValue
        if tmpPlayInfo != nil {
            self.playInfo = [DataPlayInfoUrlList]()
            for item in tmpPlayInfo! {
                self.playInfo!.append(DataPlayInfoUrlList(dict: item.dictionaryValue))
            }
        }
        
        self.campaign = dict["campaign"]
        self.webAdTrack = dict["webAdTrack"]
        self.ad = dict["ad"]!.boolValue
        self.type = dict["type"]?.stringValue
        self.titlePgc = dict["titlePgc"]?.stringValue
        self.descriptionPgc = dict["descriptionPgc"]?.stringValue
        self.remark = dict["remark"]
        self.ifLimitVideo = dict["ifLimitVideo"]?.boolValue
        self.searchWeight = dict["searchWeight"]?.intValue
        self.idx = dict["idx"]?.intValue
        self.shareAdTrack = dict["shareAdTrack"]
        self.favoriteAdTrack = dict["favoriteAdTrack"]
        self.date = dict["date"]!.uInt64Value
        self.promotion = dict["promotion"]
        self.label = dict["label"]
        self.labelList = dict["labelList"]
        self.descriptionEditor =  dict["descriptionEditor"]?.stringValue
        self.collected = dict["collected"]!.boolValue
        self.played = dict["played"]!.boolValue
        self.subtitles = dict["subtitles"]?.arrayValue.map({ return $0.stringValue
        })
        self.lastViewTime = dict["lastViewTIme"]
        self.playlists = dict["playlists"]
        self.src = dict["src"]?.intValue
    }
}



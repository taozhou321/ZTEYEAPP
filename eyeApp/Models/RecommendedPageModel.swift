//
// RecommendedPageModel.swift
// eyeApp
//
// Create by 周涛 on 2018/11/1.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import SwiftyJSON

struct RecommendedPageModel {
    enum ItemType: String {
        case squareCardCollection = "squareCardCollection"
        case textCard = "textCard"
        case banner = "banner"
        case videoSmallCard = "videoSmallCard"
        case followCard = "followCard"
        
    }
    /*
     ItemType {
     static let squareCardCollection = "squareCardCollection"
     static let textCard = "textCard"
     static let banner = "banner"
     static let videoSmallCard = "videoSmallCard"
     static let follewCard = "followCard"
     }
     */
    
    var itemList: [Any]?
    var itemTypeList: [ItemType]?
    var count: Int?
    var total: Int?
    var nextPageUrl: String?
    var adExist: Bool?
    
    init(dict: Dictionary<String, JSON>) {
        self.count = dict["count"]?.intValue
        self.total = dict["total"]?.intValue
        self.nextPageUrl = dict["nextPageUrl"]?.stringValue
        self.adExist = dict["adExist"]?.boolValue
        self.itemTypeList = [ItemType]()
        let itemlists = dict["itemList"]?.arrayValue
        if itemlists != nil {
            self.itemList = [Any]()
            for item in itemlists! {
                guard let itemDict = item.dictionary else {
                    continue
                }
                
                guard let type =  (itemDict["type"]?.stringValue) else {continue}
                
                switch ItemType(rawValue: type) {
                case .squareCardCollection?:
                    let tmp = SquareCardModel(dict: item.dictionaryValue)
                    self.itemList?.append(tmp)
                    self.itemTypeList?.append(.squareCardCollection)
                    break
                case .followCard?:
                    let tmp = FollowCardModel(dict: item.dictionaryValue)
                    self.itemList?.append(tmp)
                    self.itemTypeList?.append(.followCard)
                    break
                case .banner?:
                    /*let tmp = BannerModel(dict: item.dictionaryValue)
                    self.itemList?.append(tmp)
                    self.itemTypeList?.append(.banner)*/
                    print(type)
                    break
                case .textCard?:
                    let tmp = TextCardModel(dict: item.dictionaryValue)
                    self.itemList?.append(tmp)
                    self.itemTypeList?.append(.textCard)
                    break
                case .videoSmallCard?:
                    let tmp = VideoSmallCardModel(dict: item.dictionaryValue)
                    self.itemList?.append(tmp)
                    self.itemTypeList?.append(.videoSmallCard)
                    break
                default:
                    print(type)
                    break
                }
            }
            
        }
    }
    
    mutating func addNewRecommendedPageModel(newModel: RecommendedPageModel) -> RecommendedPageModel {
        if newModel.itemTypeList != nil && newModel.itemList != nil {
            self.itemList?.append(contentsOf: newModel.itemList!)
            self.itemTypeList?.append(contentsOf: newModel.itemTypeList!)
        }
        if self.total != nil && newModel.total != nil {
            self.total! += newModel.total!
        }
        if self.count != nil && newModel.count != nil {
            self.count! += newModel.count!
        }
        self.nextPageUrl = newModel.nextPageUrl
        return self
    
    }
}

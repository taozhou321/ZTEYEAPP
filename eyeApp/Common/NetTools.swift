//
// NetTools.swift
// eyeApp
//
// Create by 周涛 on 2018/10/17.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import Alamofire
import SwiftyJSON

enum EYERequestType {
    case GET
    case POST
}
//使用AFNetWorking
class EYENetTools: AFHTTPSessionManager {
    
    
    static let share = EYENetTools()
    
    
    
    func request(type: EYERequestType, urlStr: String, parameters: [String: Any]?,progress: ((NSObject)->Void)?, resultBlock: @escaping ([String: Any]?, Error?)->Void) {
        let successBlock = {(task: URLSessionDataTask, responseObj: Any?) in resultBlock(responseObj as? [String:Any],nil)}
        let failureBlock = {(task: URLSessionDataTask?, error: Error) in resultBlock(nil,error)}
        if type == .GET {
            get(urlStr, parameters: parameters, progress: progress, success: successBlock, failure: failureBlock)
        } else {
            post(urlStr, parameters: parameters, progress: progress, success: successBlock, failure: failureBlock)
        }
        
    }
}

//使用Alamofire
struct EYEAlamofireNetTools {
    static func request(httpMethod: EYERequestType ,url: String,parameters: Parameters?, headers: HTTPHeaders?, resultBlock: @escaping (JSON?, Error?)->Void) {
        if httpMethod == .GET {
            Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    resultBlock(JSON(value),nil)
                    break
                case .failure(let value):
                    resultBlock(nil,value)
                    break
                }
            }
        }
        
        if httpMethod == .POST {
            Alamofire.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    resultBlock(JSON(value),nil)
                    break
                case .failure(let value):
                    resultBlock(nil,value)
                    break
                }
            }
        }
    }
}



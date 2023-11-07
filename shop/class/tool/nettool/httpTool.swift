//
//  httpTool.swift
//  shop
//
//  Created by zyjz on 2023/10/31.
//
import Alamofire
import SwiftyJSON
import HandyJSON

import Foundation

class HttpTool {
    
    static func getRequest(url:String,success:@escaping(Any)->Void,fail:@escaping(Any)->Void){
        request(url: url, method: .get, params: Parameters(), success: success, fail: fail)
        
    }
    
    
    static func postRequest(url:String,params:Parameters,success:@escaping(Any)->Void,fail:@escaping(Any)->Void) {
     
        request(url: url, method: .post, params: params, success: success, fail: fail)
    }
    
    static func request(url:String,method:HTTPMethod,params:Parameters,success:@escaping(Any)->Void,fail:@escaping(Any)->Void) {
        
        AF.request(JSApi.baseUrl+url,
                   method: method,
                   parameters: params
        ).responseString(encoding:.utf8) { response in
            switch response.result {
            case .success(let string):
                let baseModel =  ResponseModel.deserialize(from: string)
                if(baseModel?.code == 200) {
                    success(baseModel?.data ?? "")
                } else {
                    fail(baseModel?.msg as Any)
                }
                break
            case .failure(let error):
                fail(error.localizedDescription)
                break
            }
            
        }
        
        
    }
    
    
    
}

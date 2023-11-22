//
//  UserInfo.swift
//  shop
//
//  Created by zyjz on 2023/11/8.
//

import Foundation
import HandyJSON

class UserInfo {
    
    static let share = UserInfo()
    
    var isLogin = false
    
    var token = ""
    
    var user = JSUserModel()
    
    func saveModel(model:JSUserModel) {
        user = model
        UserDefaults().set(isLogin, forKey: "loginFlag")
        let data = try? JSONEncoder().encode(model)
         if data != nil {
             let jsonString = String(data: data!, encoding: .utf8)
             UserDefaults().set(jsonString, forKey: "userInfo")
         }
    }
    
    func exitAccount(){
        isLogin = false
        UserDefaults().set(false, forKey: "loginFlag")
    }
    
    func getUser() {
       isLogin = UserDefaults().bool(forKey: "loginFlag")
        let jsonString:String? = UserDefaults().string(forKey: "userInfo")
        let jsonData = jsonString?.data(using: .utf8)
        if(jsonData != nil) {
         let userData = try? JSONDecoder().decode(JSUserModel.self, from: jsonData!)
            if userData != nil {
                user = userData!
            }
        }        
    }
    
    private init(){
    }
}

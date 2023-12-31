//
//  JSUserModel.swift
//  shop
//
//  Created by zyjz on 2023/11/7.
//

import Foundation
import WCDBSwift
import UIKit


final class JSUserModel:TableCodable {
  
     static let tableName = "JSUserModel"
    
    var id: Int? = nil
    var userName: String? = nil
    var nickName: String = "默认用户"
    var headIcon: String = "https://upload.jianshu.io/users/upload_avatars/6539412/69075f35-f3f1-4d33-b325-215d530b1620.jpg"
    var password: String? = nil
    required init() {}
       
    enum CodingKeys: String, CodingTableKey {
        typealias Root = JSUserModel
        case id
        case userName
        case nickName
        case headIcon
        case password
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id,isPrimary: true,isAutoIncrement: true)
        }
    }
}

extension JSUserModel {
    
    static func existAccount(userName:String)->Bool {
        
        let list:[JSUserModel] = try! WCDBUtil.share.dataBase!.getObjects(fromTable: JSUserModel.tableName
                                                                          ,where: (JSUserModel.Properties.userName==userName))
        if(list.count > 0) {
            return true
        }
        return false
    }
    
    static func loginAction(count:String,pwd:String) ->JSUserModel? {
        
        let row:JSUserModel?  =  try! WCDBUtil.share.dataBase!.getObject(fromTable: JSUserModel.tableName,
                     where:(JSUserModel.Properties.userName==count&&JSUserModel.Properties.password==pwd)
        )
        return row
    }
    
    
    func save(){
        try? WCDBUtil.share.dataBase?.insert(self, intoTable: JSUserModel.tableName)
    }
    
    func update() {
        try? WCDBUtil.share.dataBase?.update(table: JSUserModel.tableName,
                                             on: JSUserModel.Properties.all,
                                             with: self, where: (JSUserModel.Properties.id==self.id!))
    }
    
    
}



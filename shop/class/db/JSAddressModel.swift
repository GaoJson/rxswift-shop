//
//  JSAddressModel.swift
//  shop
//
//  Created by zyjz on 2023/11/27.
//

import Foundation
import WCDBSwift


final class JSAddressModel:TableCodable {
  
     static let tableName = "JSAddressModel"
    
    var id: Int? = nil
    var userId:Int = 0
    var userName:String = ""
    var phone:String = ""
    var address:String = ""
    var addressDetail:String = ""
    var defaultFlag:Bool = false
    required init() {}
       
    enum CodingKeys: String, CodingTableKey {
        typealias Root = JSAddressModel
        case id
        case userId
        case userName
        case phone
        case address
        case addressDetail
        case defaultFlag
 
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id,isPrimary: true,isAutoIncrement: true)
        }
    }
}

extension JSAddressModel {
    
    static func selectList()->[JSAddressModel]{
        let list:[JSAddressModel]? = try? WCDBUtil.share.dataBase?.getObjects(fromTable: tableName,
                                                                              where: Properties.userId==UserInfo.share.user.id!)
        if(list != nil) {
            return list!
        }else {
            return []
        }
    }
    
    func saveModel() {
        try? WCDBUtil.share.dataBase?.insert(self, intoTable: JSAddressModel.tableName)
    }
    
    static func deleteModel(model:JSAddressModel) {
        try? WCDBUtil.share.dataBase?.delete(fromTable: tableName,where:(Properties.id==model.id!))
    }
    
    static func updateModel(model:JSAddressModel) {
        try? WCDBUtil.share.dataBase?.update(table: tableName,
                                             on: Properties.all,
                                             with: model, where: (Properties.id==model.id!))
    }
    
    
}

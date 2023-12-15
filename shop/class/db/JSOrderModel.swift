//
//  JSOrderModel.swift
//  shop
//
//  Created by zyjz on 2023/12/11.
//

import Foundation
import WCDBSwift
import HandyJSON

final class JSOrderModel:TableCodable,HandyJSON {
    
    static let tableName = "JSOrderModel"
    
    var id: Int? = nil
    var userId:Int = 0
    var address:String = ""
    var price:String = ""
    var state:Int = 0
    var expressNumber:String = ""
    var content:String = ""
    var goods:String = ""
    var createTime:String=""
    var payTime:String=""
    var expressTime:String=""
    var endTime:String=""
    
    required init() {}
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = JSOrderModel
        case id
        case userId
        case address
        case price
        case state
        case expressNumber
        case content
        case goods
        case createTime
        case payTime
        case expressTime
        case endTime
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id,isPrimary: true,isAutoIncrement: true)
        }
    }
    
    var lastInsertedRowID: Int64 = 0
    
}

extension JSOrderModel {
    
    func saveModel()->Int {
        try! WCDBUtil.share.dataBase?.insert(self, intoTable: JSOrderModel.tableName)
        let list:[JSOrderModel]? =  try? WCDBUtil.share.dataBase?.getObjects(fromTable: JSOrderModel.tableName,orderBy: [JSOrderModel.Properties.id.order(.descending)],limit: 1)
        if(list != nil) {
            return list!.first!.id!
        } else {
            return -1
        }
    }
    
    static func updateModel(model:JSOrderModel) {
        try? WCDBUtil.share.dataBase?.update(table: tableName,
                                             on: JSOrderModel.Properties.all,
                                             with: model, where: (JSOrderModel.Properties.id==model.id!))
    }
    
    static func getCount(state:Int) ->Int{
        let descriptionColumn = try! WCDBUtil.share.dataBase?.getColumn(on: Properties.any.count(), fromTable: tableName,where: Properties.state==state)
        let count = descriptionColumn?.first?.int32Value ?? 0
        
        return Int(count)
    }
    
    static func selectList()->[JSOrderModel]{
        let list:[JSOrderModel]? = try? WCDBUtil.share.dataBase?.getObjects(fromTable: tableName,
                                                                              where: Properties.userId==UserInfo.share.user.id!)
        if(list != nil) {
            return list!
        }else {
            return []
        }
    }
    
    static func selectList(state:Int)->[JSOrderModel]{
        let list:[JSOrderModel]? = try? WCDBUtil.share.dataBase?.getObjects(fromTable: tableName,
                                                                            where: Properties.userId==UserInfo.share.user.id!&&Properties.state==state)
        if(list != nil) {
            return list!
        }else {
            return []
        }
    }
    
    static func selectObject(id:Int)->JSOrderModel {
        let model:JSOrderModel? = try? WCDBUtil.share.dataBase?.getObject(on: Properties.all, fromTable:tableName,where: Properties.userId==UserInfo.share.user.id!&&Properties.id==id)
        
        return model!
    }
    
    
}

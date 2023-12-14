//
//  WCDBUtil.swift
//  shop
//
//  Created by zyjz on 2023/11/8.
//

import Foundation
import WCDBSwift

class WCDBUtil {
    static let share = WCDBUtil()
    private init(){}
    
    public var dataBase:Database?
    
    public func connectDatabase() {
        if dataBase != nil {
            dataBase?.close()
        }
        
        let mainPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last ?? ""
        let fileUrl = URL(string: mainPath.appending("/appData.sqlite"))
        
        debugPrint("路径：：",fileUrl!.path)

        dataBase = Database(at: fileUrl!.path)

        createTables()
    }
    
    private func createTables() {
        try? dataBase?.create(table: JSUserModel.tableName, of: JSUserModel.self)
        try? dataBase?.create(table: JSShopCarModel.tableName, of: JSShopCarModel.self)
        try? dataBase?.create(table: JSAddressModel.tableName, of: JSAddressModel.self)
        try? dataBase?.create(table: JSOrderModel.tableName, of: JSOrderModel.self)
    }
    
    public func closeDatabase() {
        dataBase?.close()
        dataBase = nil
       }
    
}

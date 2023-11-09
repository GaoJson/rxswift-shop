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
        
        guard let fileUrl = try? FileManager.default
            .url(for: .applicationDirectory, in: .userDomainMask,appropriateFor: nil,create: true)
            .appendingPathComponent("appData.sqlite") else {return}
                
        debugPrint("路径：：",fileUrl.path)
        dataBase = Database(at: fileUrl)
        
        createTables()
    }
    
    private func createTables() {
        try? dataBase?.create(table: JSUserModel.tableName, of: JSUserModel.self)
        
        
    }
    
    public func closeDatabase() {
        dataBase?.close()
        dataBase = nil
       }
    
}

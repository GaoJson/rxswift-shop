//
//  JSStringTool.swift
//  shop
//
//  Created by zyjz on 2023/12/11.
//

import Foundation

extension String {
    
    static func newTime()->String{
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: now)
        return dateString
    }
    
    
}

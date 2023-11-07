//
//  ResponseModel.swift
//  shop
//
//  Created by zyjz on 2023/11/1.
//

import HandyJSON

import Foundation

struct ResponseModel:HandyJSON {
    var code:Int?
    var msg:String?
    var data:Any?
}


struct ResponseListModel:HandyJSON {
    var code:Int?
    var msg:String?
    var rows:Any?
    var total:Int?
}

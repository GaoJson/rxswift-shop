//
//  JSShopCarModel.swift
//  shop
//
//  Created by zyjz on 2023/11/20.
//

import Foundation
import WCDBSwift

final class JSShopCarModel:TableCodable {
    
static let tableName = "JSShopCarModel"
   
    var id: Int? = nil
    var userId:Int? = nil
    var shopId:Int? = nil
    var goodsImg:String? = nil
    var goodsBanner:String? = nil
    var goodsName:String? = nil
    var spec:String? = nil
    var goodsPrice:String? = nil
    var originalPrice:String? = nil
    var count:Int? = nil
    var selectFlag:Int?=nil
    
   required init() {}
      
   enum CodingKeys: String, CodingTableKey {
       typealias Root = JSShopCarModel
       case id
       case userId
       case shopId
       case goodsImg
       case goodsBanner
       case goodsName
       case spec
       case goodsPrice
       case originalPrice
       case count
       case selectFlag
       
       static let objectRelationalMapping = TableBinding(CodingKeys.self) {
           BindColumnConstraint(id,isPrimary: true,isAutoIncrement: true)
       }
   }
}
extension JSShopCarModel {
    
   static func savelModel(model:GoodsModel){
        let row:JSShopCarModel? = try? WCDBUtil.share.dataBase!.getObject(fromTable: JSShopCarModel.tableName,
                                           where:(JSShopCarModel.Properties.shopId==model.id&&JSShopCarModel.Properties.userId==UserInfo.share.user.id!))
        if(row == nil){
            let shopModel = JSShopCarModel()
            shopModel.count = 1
            shopModel.shopId = model.id
            shopModel.spec = model.spec
            shopModel.userId = UserInfo.share.user.id
            shopModel.goodsBanner = model.goodsBanner
            shopModel.goodsImg = model.goodsImg
            shopModel.goodsPrice = model.goodsPrice
            shopModel.goodsName = model.goodsName
            shopModel.originalPrice = model.originalPrice
            shopModel.selectFlag = 0
            try! WCDBUtil.share.dataBase?.insert(shopModel, intoTable: JSShopCarModel.tableName)
        } else {
            row?.count! += 1
            debugPrint(row!)
            try? WCDBUtil.share.dataBase?.update(table: JSShopCarModel.tableName,
                                                 on: JSShopCarModel.Properties.all,
                                                 with: row!, where: (JSShopCarModel.Properties.shopId==model.id))
        }
       Toasts.showInfo(tip: "添加成功")
    }
    
    
    static func getModelList()->[JSShopCarModel]{
        let list:[JSShopCarModel]? =  try? WCDBUtil.share.dataBase?.getObjects(fromTable: self.tableName)
        if(list != nil){
            return list!
        }else{
            return [];
        }
    }
    
    static func deleteModel(){
        try? WCDBUtil.share.dataBase?.delete(fromTable: tableName)
    }
    
    static func deleteModelWithId(id:Int){
        try? WCDBUtil.share.dataBase?.delete(fromTable: tableName,where: Properties.id==id)
        
    }
    
    static func updateModel(model:JSShopCarModel) {
        try? WCDBUtil.share.dataBase?.update(table: tableName,
                                             on: JSShopCarModel.Properties.all,
                                             with: model, where: (JSShopCarModel.Properties.id==model.id!))
    }
    
    static func selectAll(select:Bool){
        let model = JSShopCarModel()
        
        if select {
            model.selectFlag = 1
        } else {
            model.selectFlag = 0
        }
        try? WCDBUtil.share.dataBase?.update(table: tableName,
                                             on: [JSShopCarModel.Properties.selectFlag],
                                             with: model,
                                             where: Properties.userId==UserInfo.share.user.id!)
        
    }
    
}

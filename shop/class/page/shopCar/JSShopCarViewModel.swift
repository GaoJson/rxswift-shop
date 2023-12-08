//
//  JSShopCarViewModel.swift
//  shop
//
//  Created by zyjz on 2023/11/8.
//

import Foundation
import RxSwift
import RxCocoa

class JSShopCarViewModel {
    
    let bag = DisposeBag()
    
    let dataList = BehaviorRelay<[JSShopCarModel]>(value: [])
    
    var selectAllFlag = BehaviorRelay<Bool>(value: false)
    
    var goodsCount = 0
    var goodsPrice = BehaviorRelay<String>(value: "0.0")
    
    let editFlag = BehaviorRelay<Bool>(value: false)
    
    func loadList(){
        let list = JSShopCarModel.getModelList()
        dataList.accept(list)
        countPrice()
    }
    
    func countPrice(){
        var allPrice = 0.0
        var allCount = 0
        dataList.value.forEach { model in
            if model.selectFlag == 1{
                let price:Double! = Double(model.goodsPrice ?? "0")
                let count:Int! = model.count
                allPrice += price * Double(count)
                allCount += count
            }
        }
        goodsCount = allCount
        goodsPrice.accept("\(allPrice)")
    }
    
    func deleteGoods() {
        dataList.value.forEach { model in
            if model.selectFlag == 1{
                JSShopCarModel.deleteModelWithId(id: model.id!)
            }
        }
        loadList()
    }
    
}

//
//  JSMineViewModel.swift
//  shop
//
//  Created by zyjz on 2023/11/21.
//

import Foundation
import RxSwift
import RxCocoa

class JSMineViewModel {
    
    let userModel = BehaviorRelay<JSUserModel>(value: JSUserModel())
    
    let orderList = PublishSubject<[Int]>()
    
    func loadOrder(){
         var list = Array<Int>()
        list.append(JSOrderModel.getCount(state: 0))
        list.append(JSOrderModel.getCount(state: 1))
        list.append(JSOrderModel.getCount(state: 2))
        list.append(JSOrderModel.getCount(state: 3))
        orderList.onNext(list)
    }
    
    
    
}

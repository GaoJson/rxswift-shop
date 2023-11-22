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
    
    
    func loadList(){
        let list = JSShopCarModel.getModelList()
        dataList.accept(list)
    }
    
    
    
}

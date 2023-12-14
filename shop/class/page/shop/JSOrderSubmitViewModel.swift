//
//  JSOrderSubmitViewModel.swift
//  shop
//
//  Created by zyjz on 2023/12/11.
//

import Foundation
import RxSwift

class JSOrderSubmitViewModel {
    
    var addreModel:JSAddressModel?
    
    let addressModel = PublishSubject<JSAddressModel>()
    
    func getAddress() {
        let list = JSAddressModel.selectList()
        if(list.isEmpty) {
            addressModel.onNext(JSAddressModel())
        } else {
            var tempModel:JSAddressModel?
            list.forEach { model in
                if(model.defaultFlag) {
                    tempModel = model
                    return
                }
            }
            if tempModel==nil {
                tempModel = list.first
            }
            addressModel.onNext(tempModel!)
        }
    }
}

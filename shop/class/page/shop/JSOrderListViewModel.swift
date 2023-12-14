//
//  JSOrderListViewModel.swift
//  shop
//
//  Created by zyjz on 2023/12/12.
//

import Foundation
import RxSwift
import RxCocoa

class JSOrderListViewModel {
    var currectIndex = 0
    
    var tableView:UITableView?
    
    let orderList = BehaviorRelay<[JSOrderModel]>(value: [])
    
    func loadData() {
        var list = Array<JSOrderModel>()
        if (currectIndex == 0) {
            list = JSOrderModel.selectList()
        } else {
            list = JSOrderModel.selectList(state: currectIndex-1)
        }
        if (list.count == 0) {
            tableView?.noData?.isHidden = false
        } else {
            tableView?.noData?.isHidden = true
        }
        
        orderList.accept(list)
    }
}

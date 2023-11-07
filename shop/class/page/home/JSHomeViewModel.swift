//
//  JSHomeViewModel.swift
//  shop
//
//  Created by zyjz on 2023/11/2.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources


typealias NumberSection = SectionModel<String,GoodsModel>


class JSHomeViewModel:NSObject {
    
    let topModel = BehaviorRelay<HomeModel>(value: HomeModel())
    let models = BehaviorRelay<[NumberSection]>(value: [])
   
    var page = 1
    
    var disposeBag = DisposeBag()
    
    let refreshStatus = BehaviorRelay<JSRefreshStatus>(value: .none)
    
    
    override init() {
            
    }
    
    func loadTopData() {
        HttpTool.getRequest(url: JSApi.goodsMain) {[weak self] res in
            let model = HomeModel.deserialize(from: res as? Dictionary<String, Any>)
            self?.topModel.accept(model!)
            self?.refreshStatus.accept(.endHeaderRefresh)
        } fail: { error in
            self.refreshStatus.accept(.endHeaderRefresh)
        }
    }
    
    func loadMoreData() {
         let params = [
            "pageNum":page,
            "pageSize":6
         ]
        HttpTool.postRequest(url: JSApi.goodsList, params: params) { res in
            let listModel = ResponseListModel.deserialize(from: res as? Dictionary<String, Any>)
            let arr = listModel!.rows as! Array<Dictionary<String, Any>>
            let list = Array<GoodsModel>.deserialize(from: arr) as! Array<GoodsModel>
            var array =  self.models.value.first?.items
            
            array = self.page==1 ?list:(array ?? [])+list
            
            self.models.accept([SectionModel(model: "1", items:array ?? [] )])
            self.refreshStatus.accept(.endFooterRefresh)
        } fail: { error in
            self.refreshStatus.accept(.endFooterRefresh)
        }

        
        
        
    }
    
    
    
}

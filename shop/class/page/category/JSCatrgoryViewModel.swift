//
//  JSCatrgoryViewModel.swift
//  shop
//
//  Created by zyjz on 2023/11/7.
//

import Foundation
import RxRelay

class JSCatrgoryViewModel {
    
    var page = 1
    var cid = 0
    
    let leftList = BehaviorRelay<[CategoryModel]>(value: [])
    let rightList = BehaviorRelay<[GoodsModel]>(value: [])
    
    var rightTable:UITableView?
    
    let refreshStatus = BehaviorRelay<JSRefreshStatus>(value: .none)
    
    func loadLeftData(){
        HttpTool.getRequest(url: JSApi.goodsMain) {[weak self] res in
            let model = HomeModel.deserialize(from: res as? Dictionary<String, Any>)
            self?.leftList.accept(model?.tgoodsCategoryVos ?? [])
            self?.loadRightData(cid: model?.tgoodsCategoryVos[1].id ?? 0)
            self?.refreshStatus.accept(.beingHeaderRefresh)
        } fail: { error in
            
        }
    }
    
    func loadRightData(cid:Int) {
        self.cid = cid
        let params = [
           "pageNum":page,
           "pageSize":10,
           "goodsCid":cid
        ]
        HttpTool.postRequest(url: JSApi.goodsList, params: params) {[weak self] res in
            let listModel = ResponseListModel.deserialize(from: res as? Dictionary<String, Any>)
            let arr = listModel!.rows as! Array<Dictionary<String, Any>>
            let list = Array<GoodsModel>.deserialize(from: arr) as! Array<GoodsModel>
            var array =  self?.rightList.value
            array = self?.page==1 ?list:(array ?? [])+list
            self?.rightList.accept(array ?? [])
            self?.refreshStatus.accept(.endHeaderRefresh)
            self?.refreshStatus.accept(.endFooterRefresh)
            
            if(array!.count >= (listModel?.total)!) {
                self?.refreshStatus.accept(.noMoreData)
            }
            if (array?.count == 0) {
                self?.rightTable?.noData?.isHidden = false
            } else {
                self?.rightTable?.noData?.isHidden = true
            }
        } fail: { error in
            self.refreshStatus.accept(.endFooterRefresh)
            self.refreshStatus.accept(.endHeaderRefresh)
        }
    }
    
    
    
}

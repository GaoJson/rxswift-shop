//
//  JSShopCarViewController.swift
//  shop
//
//  Created by zyjz on 2023/11/7.
//

import UIKit
import RxSwift
import RxDataSources

class JSShopCarViewController: UIViewController {

    let viewModel = JSShopCarViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购物车"
        setUI()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadList()
    }
    
    func setUI() {
        self.view.backgroundColor = .bckColor
        
        
        let buyBottomView = UIView()
        buyBottomView.backgroundColor = .white
        self.view.addSubview(buyBottomView)
        buyBottomView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-(UIDevice.TABBAR_HEIGHT+UIDevice.BOTTOM_HEIGHT))
            make.height.equalTo(40)
        }
        
        let tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.bottom.equalTo(buyBottomView.snp_bottomMargin)
            make.top.equalTo(UIDevice.NAV_HEIGHT+UIDevice.STATUS_HEIGHT)
        }
        tableView.rowHeight = 100
        tableView.register(UINib(nibName: "JSShopCarItemCell", bundle: nil), forCellReuseIdentifier: "JSShopCarItemCell")
       
        
        viewModel.dataList.asDriver().drive(tableView.rx.items(cellIdentifier: "JSShopCarItemCell", cellType: JSShopCarItemCell.self)){
            (row,model,cell) in
            cell.setModel(model: model,bag: self.viewModel.bag)
            cell.selectionStyle = .none
        }.disposed(by: viewModel.bag)
        
        tableView.rx.itemSelected.subscribe{ index in

    
            
        }.disposed(by: viewModel.bag)
        
                                            
        
        
        
    }

   

}

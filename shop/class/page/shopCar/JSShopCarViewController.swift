//
//  JSShopCarViewController.swift
//  shop
//
//  Created by zyjz on 2023/11/7.
//

import UIKit

class JSShopCarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        
        
        setUI()
        
        
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
        
        
        
        
    }

   

}

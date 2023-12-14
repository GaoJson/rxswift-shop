//
//  JSAddressViewController.swift
//  shop
//
//  Created by zyjz on 2023/11/27.
//

import UIKit
import RxSwift
import RxCocoa

class JSAddressViewController: JSBaseViewController {
    
    var selectFlag = false
    
    var selectCallback: ((_ model: JSAddressModel) -> ())? = nil
    
    let disposeBag = DisposeBag()
    
    let addressList = BehaviorRelay<[JSAddressModel]>(value: [])
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .bckColor
        self.title = "我的地址"
        self.setUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let list = JSAddressModel.selectList()
        addressList.accept(list)
        
        if #available(iOS 13.0, *) {
            let appear = UINavigationBarAppearance()
            appear.backgroundColor = .white
            appear.backgroundEffect = nil
            appear.shadowColor = .clear
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.scrollEdgeAppearance = appear
            self.navigationController?.navigationBar.standardAppearance = appear
        } else {
            // Fallback on earlier versions
        }
    }

    
    func setUI() {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.register(UINib(nibName: "JSAddressCell", bundle: nil), forCellReuseIdentifier: "JSAddressCell")
        self.view.addSubview(tableView)
        tableView.rowHeight = 90
        tableView.snp.makeConstraints { make in
            make.top.equalTo(UIDevice.NAV_HEIGHT+UIDevice.STATUS_HEIGHT+10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-(UIDevice.BOTTOM_HEIGHT+50))
        }
        
        addressList.bind(to: tableView.rx.items){ (tv,index,model) in
            let cell:JSAddressCell = tv.dequeueReusableCell(withIdentifier: "JSAddressCell") as! JSAddressCell
            cell.index = index
            cell.addressLb.text = model.address
            cell.addressDetailLb.text = model.addressDetail
            cell.userLb.text = model.userName + "   " + model.phone
            cell.callBack = { idx in
                let vc = JSEditAddressViewController()
                vc.editModel = self.addressList.value[idx]
                self.navigationController?.pushViewController(vc, animated: true)
              
            }
            return cell
        }.disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe { index in
            if(self.selectFlag) {
               let model = self.addressList.value[index.element!.row]
               self.selectCallback?(model)
                self.navigationController?.popViewController(animated: true)
            }
        }.disposed(by: disposeBag)
        
        
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(0)
            make.top.equalTo(tableView.snp.bottom).offset(5)
        }
        let addBtn = UIButton(type: .custom)
        addBtn.setTitle("添加地址", for: .normal)
        addBtn.setTitleColor(.white, for: .normal)
        addBtn.backgroundColor = .red
        addBtn.layer.cornerRadius = 15
        addBtn.titleLabel?.font = .systemFont(ofSize: 14)
        
        bottomView.addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.top.equalTo(10)
            make.height.equalTo(30)
        }
        addBtn.rx.tap.subscribe { _ in
            self.navigationController?.pushViewController(JSEditAddressViewController(), animated: true)
            
        }.disposed(by: disposeBag)
    }

}

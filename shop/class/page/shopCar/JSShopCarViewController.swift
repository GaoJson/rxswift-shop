//
//  JSShopCarViewController.swift
//  shop
//
//  Created by zyjz on 2023/11/7.
//

import UIKit
import RxSwift
import RxDataSources

class JSShopCarViewController: JSBaseViewController {

    let viewModel = JSShopCarViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购物车"
        setUI()
        
        UserInfo.share.shopCarNotice.subscribe { _ in
          let count = JSShopCarModel.allCount()
            if (count > 0) {
                self.navigationController?.tabBarItem.badgeValue = "\(count)"
            }else {
                self.navigationController?.tabBarItem.badgeValue = nil
            }
        }.disposed(by: viewModel.bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadList()
    }
    
    func setUI() {
       
        let buyBottomView = UIView()
        viewModel.bottomView = buyBottomView
        buyBottomView.backgroundColor = .white
        self.view.addSubview(buyBottomView)
        buyBottomView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-(UIDevice.TABBAR_HEIGHT+UIDevice.BOTTOM_HEIGHT))
            make.height.equalTo(45)
        }
        setBottomView(bottomView: buyBottomView)
        
        let tableView = UITableView()
        tableView.backgroundColor = .bckColor
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.bottom.equalTo(buyBottomView.snp.top)
            make.top.equalTo(UIDevice.NAV_HEIGHT+UIDevice.STATUS_HEIGHT)
        }
        tableView.rowHeight = 100
        tableView.register(UINib(nibName: "JSShopCarItemCell", bundle: nil), forCellReuseIdentifier: "JSShopCarItemCell")
        viewModel.tableView = tableView
        
        viewModel.dataList.asDriver().drive(tableView.rx.items(cellIdentifier: "JSShopCarItemCell", cellType: JSShopCarItemCell.self)){
            (row,model,cell) in
            cell.setModel(model: model,viewModels: self.viewModel)
            cell.selectionStyle = .none
        }.disposed(by: viewModel.bag)
    }
    
    func setBottomView(bottomView:UIView){
        
        let barBtn = UIBarButtonItem(title: "编辑", style: .done, target: self, action: nil);
        self.navigationItem.rightBarButtonItem = barBtn
        barBtn.rx.tap.subscribe {[weak self] _ in
            let select = self!.viewModel.editFlag.value
            if select {
                barBtn.title = "编辑"
            } else{
                 barBtn.title = "完成"
            }
            self?.viewModel.editFlag.accept(!select)

        }.disposed(by: viewModel.bag)
        
     
        let selectAllBtn = UIButton(type: .custom)
        bottomView.addSubview(selectAllBtn)
        selectAllBtn.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(7)
            make.height.equalTo(26)
            make.width.equalTo(60)
        }
        let selectAllImg = UIImageView(image: R.image.icon_shop_car_un_select())
        selectAllBtn.addSubview(selectAllImg)
        selectAllImg.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.height.equalTo(26)
            make.width.equalTo(26)
            make.top.equalTo(0)
        }
        let selectAllText = UILabel()
        selectAllText.text = "全选"
        selectAllText.font = .systemFont(ofSize: 14)
        selectAllBtn.addSubview(selectAllText)
        selectAllText.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.height.equalTo(26)
            make.top.equalTo(0)
        }
        
        selectAllBtn.rx.tap.subscribe {[weak self] ele in
            let all = self!.viewModel.selectAllFlag.value
            JSShopCarModel.selectAll(select: !all)
            self!.viewModel.selectAllFlag.accept(!all)
            self!.viewModel.loadList()
        }.disposed(by: viewModel.bag)
        viewModel.selectAllFlag.subscribe { e in
            if(e.element!){
                selectAllImg.image = R.image.icon_shop_car_select()
            } else {
                selectAllImg.image = R.image.icon_shop_car_un_select()
            }
        }.disposed(by: viewModel.bag)
        
        
        
        let allprice = UILabel()
        allprice.text = "合计:"
        bottomView.addSubview(allprice)
        allprice.font = .systemFont(ofSize: 13)
        allprice.textColor = .gray
        allprice.snp.makeConstraints { make in
            make.bottom.equalTo(-7)
            make.left.equalTo(selectAllBtn.snp.right).offset(12)
        }
        let allpriceCur = UILabel()
        allpriceCur.text = "¥"
        bottomView.addSubview(allpriceCur)
        allpriceCur.font = .systemFont(ofSize: 13)
        allpriceCur.textColor = .red
        allpriceCur.snp.makeConstraints { make in
            make.bottom.equalTo(-7)
            make.left.equalTo(allprice.snp.right).offset(0)
        }
        let allpriceValue = UILabel()
        allpriceValue.text = "123.13"
        bottomView.addSubview(allpriceValue)
        allpriceValue.font = .systemFont(ofSize: 18)
        allpriceValue.textColor = .red
        allpriceValue.snp.makeConstraints { make in
            make.bottom.equalTo(-7)
            make.left.equalTo(allpriceCur.snp.right).offset(2)
        }
        
        let buyBtn = UIButton(type: .custom)
        buyBtn.setTitle("  去付款(10)  ", for: .normal)
        buyBtn.titleLabel?.font = .systemFont(ofSize: 14)
        buyBtn.backgroundColor = .red
        buyBtn.layer.cornerRadius = 15
        bottomView.addSubview(buyBtn)
        buyBtn.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        buyBtn.rx.tap.subscribe { _ in
            let list = self.viewModel.getSelectGoods()
            if(list.count == 0) {
                Toasts.showInfo(tip: "暂无选择商品")
                return
            }
            let vc = JSOrderSubmitViewController()
            vc.goodsList = list
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: viewModel.bag)
        
        viewModel.goodsPrice.subscribe { value in
            allpriceValue.text = value
            buyBtn.setTitle("  去付款(\(self.viewModel.goodsCount))  ", for: .normal)
        }.disposed(by: viewModel.bag)
        
        
        let editView = UIView()
        editView.backgroundColor = .white
        bottomView.addSubview(editView)
        editView.snp.makeConstraints { make in
            make.top.bottom.right.equalTo(0)
            make.left.equalTo(selectAllBtn.snp.right)
        }
        viewModel.editFlag.subscribe { value in
            editView.isHidden = !value
        }.disposed(by: viewModel.bag)
        
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.setTitle("     删除    ", for: .normal)
        deleteBtn.setTitleColor(.red, for: .normal)
        deleteBtn.layer.borderColor = UIColor.red.cgColor
        deleteBtn.layer.borderWidth = 1
        deleteBtn.titleLabel?.font = .systemFont(ofSize: 14)
        deleteBtn.layer.cornerRadius = 15
        editView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        deleteBtn.rx.tap.subscribe {[weak self] _ in
            guard (self != nil) else {
                return
            }
            self!.viewModel.deleteGoods()
        }.disposed(by: viewModel.bag)
    }
}

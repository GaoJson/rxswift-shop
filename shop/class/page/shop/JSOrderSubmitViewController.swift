//
//  JSOrderSubmitViewController.swift
//  shop
//
//  Created by zyjz on 2023/12/11.
//

import UIKit
import RxSwift

class JSOrderSubmitViewController: JSBaseViewController {
    
    var goodsList:Array<JSShopCarModel>?
    let viewModel = JSOrderSubmitViewModel()
    var disposeBag = DisposeBag()
    var allPrice = 0.0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单支付"
        setUI()
        viewModel.getAddress()
    }
  

    func setUI() {
        let contentView = UIScrollView()
        contentView.alwaysBounceVertical = true
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
  
        let addressView = setAddressView(view: contentView)
        let goodView = setGoodssView(contentView: contentView, addressView: addressView)
        setCountView(contentView: contentView, lastView: goodView)
        
        
        let bottomView = UIView()
        self.view.addSubview(bottomView)
        bottomView.backgroundColor = .white
        bottomView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.height.equalTo(40+UIDevice.BOTTOM_HEIGHT)
            make.bottom.equalTo(0)
        }
        
        let buyBtn = UIButton()
        bottomView.addSubview(buyBtn)
        buyBtn.titleLabel?.font = .systemFont(ofSize: 16)
        buyBtn.layer.cornerRadius = 15
        buyBtn.backgroundColor = .red
        buyBtn.setTitle("结算", for: .normal)
        buyBtn.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.height.equalTo(30)
            make.top.equalTo(8)
            make.width.equalTo(200.w)
        }
        buyBtn.rx.tap.subscribe { _ in
            self.submitAction()
        }.disposed(by: disposeBag)
    }
    
    func setAddressView(view:UIScrollView) -> UIView {
        let addressView = UIButton()
        view.addSubview(addressView)
        addressView.backgroundColor = .white
        addressView.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.left.equalTo(0)
            make.width.equalTo(UIDevice.SCREEN_WIDTH)
            make.height.equalTo(90)
        }
        addressView.rx.tap.subscribe { _ in
            let vc = JSAddressViewController()
            vc.selectFlag = true
            vc.selectCallback = { model in
                self.viewModel.addressModel.onNext(model)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }.disposed(by: disposeBag)
        
        let detailLb = UILabel()
        detailLb.text = ""
        detailLb.font = .systemFont(ofSize: 16)
        detailLb.textColor = .black
        addressView.addSubview(detailLb)
        detailLb.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.centerY.equalToSuperview()
        }
        
        let areaLb = UILabel()
        areaLb.text = ""
        areaLb.font = .systemFont(ofSize: 14)
        areaLb.textColor = .black66
        addressView.addSubview(areaLb)
        areaLb.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.bottom.equalTo(detailLb.snp.top).offset(-5)
        }
        
        let userLb = UILabel()
        userLb.text = ""
        userLb.font = .systemFont(ofSize: 14)
        userLb.textColor = .black66
        addressView.addSubview(userLb)
        userLb.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.top.equalTo(detailLb.snp.bottom).offset(5)
        }
        
        let arrow = UIImageView()
        arrow.image = R.image.icon_arrow_right_gray()
        addressView.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-8)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        let noDataView = UILabel()
        noDataView.backgroundColor = .white
        addressView.addSubview(noDataView)
        noDataView.text = "暂无地址，点击添加"
        noDataView.textAlignment = .center
        noDataView.textColor = .black99
        noDataView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        noDataView.isHidden = true
        
        viewModel.addressModel.subscribe { ele in
            let model:JSAddressModel = ele.element!
            self.viewModel.addreModel = model
            if(model.id != nil) {
                areaLb.text = model.address
                detailLb.text = model.addressDetail
                userLb.text = model.userName + "    " + model.phone
                noDataView.isHidden = true
            } else{
                noDataView.isHidden = false
            }
            
        }.disposed(by: disposeBag)
        return addressView
    }
    
    func setGoodssView(contentView:UIScrollView,addressView:UIView) -> UIView {
        var view:UIView?
        var price = 0.0
        for i in 0 ..< (goodsList?.count ?? 0) {
            let model = goodsList![i]
            price += (Double(model.goodsPrice!)! * Double(model.count!))
            let goodsView = UIView()
            goodsView.backgroundColor = .white
            contentView.addSubview(goodsView)
            goodsView.snp.makeConstraints { make in
                make.left.equalTo(0)
                make.width.equalTo(UIDevice.SCREEN_WIDTH)
                make.height.equalTo(90)
                make.top.equalTo(addressView.snp.bottom).offset(8+90.5*Double(i))
            }
            
            let img = UIImageView()
            goodsView.addSubview(img)
            img.kf.setImage(with: URL(string: model.goodsImg!))
            img.snp.makeConstraints { make in
                make.top.equalTo(8)
                make.left.equalTo(8)
                make.width.height.equalTo(75)
            }
            
            let nameLb = UILabel()
            nameLb.text = model.goodsName
            nameLb.font = .systemFont(ofSize: 13)
            nameLb.textColor = .black33
            nameLb.numberOfLines = 2
            goodsView.addSubview(nameLb)
            nameLb.snp.makeConstraints { make in
                make.left.equalTo(img.snp.right).offset(10)
                make.right.equalTo(-8)
                make.top.equalTo(img.snp.top)
            }
            
            let specLb = UILabel()
            specLb.text = model.spec
            specLb.font = .systemFont(ofSize: 12)
            specLb.textColor = .black99
            goodsView.addSubview(specLb)
            specLb.snp.makeConstraints { make in
                make.left.equalTo(img.snp.right).offset(10)
                make.right.equalTo(-8)
                make.top.equalTo(nameLb.snp.bottom).offset(5)
            }
            
            let priceLb = UILabel()
            priceLb.text = "¥\(Double(model.goodsPrice!) ?? 0.0)"
            priceLb.font = .systemFont(ofSize: 16)
            priceLb.textColor = .red
            goodsView.addSubview(priceLb)
            priceLb.snp.makeConstraints { make in
                make.left.equalTo(img.snp.right).offset(10)
                make.bottom.equalTo(img.snp.bottom)
            }
            
            let contLb = UILabel()
            contLb.text = "x\(model.count ?? 0)"
            contLb.font = .systemFont(ofSize: 14)
            contLb.textColor = .black99
            goodsView.addSubview(contLb)
            contLb.snp.makeConstraints { make in
                make.right.equalTo(-12)
                make.centerY.equalTo(priceLb)
               
            }
            if(i == goodsList!.count-1) {
                view = goodsView
            }
        }
        self.allPrice = price
        
        return view!
    }
    
    func setCountView(contentView:UIScrollView,lastView:UIView) {
        let countView = UIView()
        contentView.addSubview(countView)
        countView.backgroundColor = .white
        countView.snp.makeConstraints { make in
            make.top.equalTo(lastView.snp.bottom).offset(8)
            make.left.equalTo(0)
            make.width.equalTo(UIDevice.SCREEN_WIDTH)
            make.height.equalTo(180)
        }
        
        let titleList = ["商品价格","退换货免运费","运费","优惠卷"]
        for i in 0 ..< titleList.count {
            let titleLb = UILabel()
            titleLb.text = titleList[i]
            titleLb.font = .systemFont(ofSize: 15)
            titleLb.textColor = .black66
            countView.addSubview(titleLb)
            titleLb.snp.makeConstraints { make in
                make.left.equalTo(10)
                make.top.equalTo(i*30+5)
                make.height.equalTo(30)
            }
            
            let priceLb = UILabel()
            priceLb.text = i==0 ? "¥\(allPrice)" :"0.0"
            priceLb.font = .boldSystemFont(ofSize: 15)
            priceLb.textColor = .black66
            countView.addSubview(priceLb)
            priceLb.snp.makeConstraints { make in
                make.right.equalTo(-10)
                make.top.equalTo(i*30+5)
                make.height.equalTo(30)
            }
        }
        
        let line = UIView()
        line.backgroundColor = .bckColor
        countView.addSubview(line)
        line.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(4*30+15)
        }
        
        let allPriceLb = UILabel()
        allPriceLb.text = "¥\(allPrice)"
        allPriceLb.font = .boldSystemFont(ofSize: 16)
        allPriceLb.textColor = .red
        countView.addSubview(allPriceLb)
        allPriceLb.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.top.equalTo(line).offset(10)
            make.height.equalTo(30)
        }
        let tipLb = UILabel()
        tipLb.text = "总计："
        tipLb.font = .systemFont(ofSize: 13)
        tipLb.textColor = .black99
        countView.addSubview(tipLb)
        tipLb.snp.makeConstraints { make in
            make.right.equalTo(allPriceLb.snp.left).offset(3)
            make.centerY.equalTo(allPriceLb)
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(countView)
        }
        
    }
    
    func submitAction() {
        let data = self.goodsList?.toJSONString()
        let order = JSOrderModel()
        order.state = 0
        order.goods = data ?? ""
        order.address = "\(viewModel.addreModel!.address) \(viewModel.addreModel!.addressDetail) \(viewModel.addreModel!.userName) \(viewModel.addreModel!.phone)"
        order.createTime = String.newTime()
        order.price = "\(allPrice)"
        order.userId = UserInfo.share.user.id!
        let orderId = order.saveModel()
        order.id = orderId
        
        goodsList?.forEach({ model in
            JSShopCarModel.deleteModelWithId(id: model.id!)
        })
        
        let alert = UIAlertController(title: "输入支付密码", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            order.state = 1
            order.payTime = String.newTime()
            JSOrderModel.updateModel(model: order)
            Toasts.showInfo(tip: "支付成功")
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            Toasts.showInfo(tip: "支付失败")
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addTextField { tf in
            tf.isSecureTextEntry = true
            tf.keyboardType = .numberPad
        }
        self.present(alert, animated: true)
        
    }
    
    
}

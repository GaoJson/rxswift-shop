//
//  JSOrderDetailViewController.swift
//  shop
//
//  Created by zyjz on 2023/12/14.
//

import UIKit

class JSOrderDetailViewController: JSBaseViewController {

    var orderId = 0
    
    var goodsList:Array<JSShopCarModel> = []
    var allPrice = 0.0
    var orderModel:JSOrderModel?
    var itemList:Array<UIButton>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        
    }
    
    func loadData() {
        let model = JSOrderModel.selectObject(id: orderId)
        orderModel = model
        let goods = try! JSONSerialization.jsonObject(with: model.goods.data(using: .utf8)!)
        let arr = goods as! Array<Dictionary<String, Any>>
        goodsList = Array<JSShopCarModel>.deserialize(from: arr) as! Array<JSShopCarModel>
        setUI()
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
        contentView.contentSize = CGSizeMake(UIDevice.SCREEN_WIDTH,UIDevice.SCREEN_HEIGHT)
       let goodView = setGoodssView(contentView: contentView)
        setOrderInfo(contentView: contentView, view: goodView)
        
        
        let bottomView = UIView()
        self.view.addSubview(bottomView)
        bottomView.backgroundColor = .white
        bottomView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.height.equalTo(50+UIDevice.BOTTOM_HEIGHT)
            make.bottom.equalTo(0)
        }
        
        var itemList = Array<UIButton>()
        for _ in 0 ..< 4 {
            let btn = UIButton()
            bottomView.addSubview(btn)
            btn.setTitle("", for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 13)
            btn.layer.borderColor = UIColor.black66.cgColor
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 15
            btn.setTitleColor(.black66, for: .normal)
            btn.snp.makeConstraints { make in
                if itemList.last != nil {
                    make.right.equalTo(itemList.last!.snp.left).offset(-5)
                } else {
                    make.right.equalTo(-10)
                }
                make.top.equalTo(10)
                make.height.equalTo(30)
            }
            btn.addTarget(self, action: #selector(itemAction(btn: )), for: .touchUpInside)
           
            itemList.append(btn)
        }
        self.itemList = itemList
        setMenuItem(list: itemList, model: self.orderModel!)
    }
    

    func setGoodssView(contentView:UIScrollView) -> UIView {
        var view:UIView?
        var price = 0.0
        for i in 0 ..< (goodsList.count) {
            let model = goodsList[i]
            price += (Double(model.goodsPrice!)! * Double(model.count!))
            let goodsView = UIView()
            goodsView.backgroundColor = .white
            contentView.addSubview(goodsView)
            goodsView.snp.makeConstraints { make in
                make.left.equalTo(0)
                make.width.equalTo(UIDevice.SCREEN_WIDTH)
                make.height.equalTo(90)
                make.top.equalTo(8+90.5*Double(i))
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
            if(i == goodsList.count-1) {
                view = goodsView
            }
        }
        self.allPrice = price
        
        return view!
    }
    
    func setOrderInfo(contentView:UIScrollView,view:UIView) {
        
        let titleArray = ["商品总价","运费","支付优惠","实付款","收货信息","创建时间","支付时间","发货时间","完成时间"]
        let valueArray = ["¥\(orderModel!.price)","¥0.0","¥0.0","¥\(orderModel!.price)",orderModel?.address,orderModel?.createTime,orderModel?.payTime,orderModel?.expressTime,orderModel?.endTime]
        
        let bckView = UIView()
        bckView.backgroundColor = .white
        contentView.addSubview(bckView)
        
        var tempView:UIView?
        for i in 0 ..< titleArray.count {
            let valueLb = UILabel()
            valueLb.text = " \(valueArray[i] ?? " ")"
            valueLb.textColor = .black66
            valueLb.textAlignment = .right
            valueLb.numberOfLines = 2
            valueLb.font = .systemFont(ofSize: 14)
            contentView.addSubview(valueLb)
            valueLb.snp.makeConstraints { make in
                make.left.equalTo(100)
                make.width.equalTo(UIDevice.SCREEN_WIDTH-110)
                if(tempView == nil) {
                    make.top.equalTo(view.snp.bottom).offset(20)
                }else {
                    make.top.equalTo(tempView!.snp.bottom).offset(12)
                }
            }
            if(i == 3){
                valueLb.font = .systemFont(ofSize: 16)
                valueLb.textColor = .red
            }
            tempView = valueLb
            
            let titleLb = UILabel()
            titleLb.text = titleArray[i]
            titleLb.font = .boldSystemFont(ofSize: 15)
            titleLb.textColor = .black
            contentView.addSubview(titleLb)
            titleLb.snp.makeConstraints { make in
                make.left.equalTo(8)
                make.centerY.equalTo(valueLb)
            }
            
            
        }
       
        bckView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.width.equalTo(UIDevice.SCREEN_WIDTH)
            make.top.equalTo(view.snp.bottom).offset(8)
            make.bottom.equalTo(tempView!).offset(10)
        }
        
        
        
        
        
        
        
        
    }
    
    
    func setMenuItem(list:Array<UIButton>,model:JSOrderModel) {
        list.forEach { btn in
            btn.isHidden = true
        }
        var title = ""
        if model.state==0 {
            title = "已取消"
            list[0].isHidden = false
            list[0].setTitle("  去支付  ", for:.normal)
            list[1].isHidden = false
            list[1].setTitle("  取消订单  ", for:.normal)
        }
        if model.state==1 {
            title = "待支付"
            list[0].isHidden = false
            list[0].setTitle("  去发货  ", for:.normal)
            list[1].isHidden = false
            list[1].setTitle("  催发货  ", for:.normal)
        }
        if model.state==2 {
            title = "待发货"
            list[0].isHidden = false
            list[0].setTitle("  确认收货  ", for:.normal)
            list[1].isHidden = false
            list[1].setTitle("  查看物流  ", for:.normal)
        }
        
        if model.state==3 {
            title = model.content.count==0 ? "待评价" : "已完成"
            if(model.content.count == 0) {
                list[0].isHidden = false
                list[0].setTitle("  去评价  ", for:.normal)
                list[1].isHidden = false
                list[1].setTitle("  删除订单  ", for:.normal)
            } else {
                list[0].isHidden = false
                list[0].setTitle("  删除订单  ", for:.normal)
            }
        }
        self.title = title
    }
    
    @objc func itemAction(btn:UIButton){
       let title = btn.currentTitle!
        switch (title) {
        case "  去支付  ":
            let alert = UIAlertController(title: "输入支付密码", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                self.orderModel?.state = 1
                self.orderModel?.payTime = String.newTime()
                JSOrderModel.updateModel(model: self.orderModel!)
                Toasts.showInfo(tip: "支付成功")
                self.setMenuItem(list: self.itemList!, model: self.orderModel!)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                
                    
            }))
            alert.addTextField { tf in
                tf.isSecureTextEntry = true
                tf.keyboardType = .numberPad
            }
            self.present(alert, animated: true)
            break
        case "  去发货  ":
            let alert = UIAlertController(title: "输入快递单号", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                self.orderModel?.state = 2
                self.orderModel?.expressTime = String.newTime()
                self.orderModel?.expressNumber = alert.textFields?.first?.text ?? ""
                JSOrderModel.updateModel(model: self.orderModel!)
                Toasts.showInfo(tip: "发货成功")
                self.setMenuItem(list: self.itemList!, model: self.orderModel!)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
               
                    
            }))
            alert.addTextField { tf in
                tf.keyboardType = .numberPad
            }
            self.present(alert, animated: true)
            
            break
            
        case "  确认收货  ":
            let alert = UIAlertController(title: "是否确认收货", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                self.orderModel?.state = 3
                self.orderModel?.endTime = String.newTime()
                JSOrderModel.updateModel(model: self.orderModel!)
                Toasts.showInfo(tip: "确认收货成功")
                self.setMenuItem(list: self.itemList!, model: self.orderModel!)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
               
                    
            }))

            self.present(alert, animated: true)
            
            break
        case "  去评价  ":
            let alert = UIAlertController(title: "评论", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                self.orderModel?.content = alert.textFields?.first?.text ?? ""
                JSOrderModel.updateModel(model: self.orderModel!)
                Toasts.showInfo(tip: "评论成功")
                self.setMenuItem(list: self.itemList!, model: self.orderModel!)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
               
                    
            }))
            alert.addTextField { tf in
                tf.keyboardType = .numberPad
                tf.placeholder = "请输入评论"
            }
            self.present(alert, animated: true)
            
            break
            
        case "  取消订单  ":
            
            
            break
            
            
            
        default:
            break
        }
        
        
    }
    
}

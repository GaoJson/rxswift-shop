//
//  JSOrderListViewController.swift
//  shop
//
//  Created by zyjz on 2023/12/12.
//

import UIKit
import RxSwift
import RxCocoa

class JSOrderListViewController: JSBaseViewController {

    let viewModel = JSOrderListViewModel()
    let disponseBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
   
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的订单"
        setUI()
        viewModel.loadData()
    }
    
    
    func setUI() {
        topView()
        listView()
    }
    
    func topView() {
        let topView = UIView()
        topView.backgroundColor = .white
        self.view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(UIDevice.NAV_HEIGHT+UIDevice.STATUS_HEIGHT)
        }
        
        let list = ["全部","待支付","待发货","已发货","已完成"]
        var btnList = Array<UIButton>()
        for i in 0 ..< list.count {
            let btn = UIButton()
            btn.titleLabel?.font = .systemFont(ofSize: 14)
            btn.setTitle(list[i], for: .normal)
            btn.setTitleColor(.black33, for: .normal)
            btn.setTitleColor(.red, for: .selected)
            topView.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.width.equalTo(UIDevice.SCREEN_WIDTH/5)
                make.top.bottom.equalTo(0)
                make.left.equalTo(i*Int(UIDevice.SCREEN_WIDTH)/5)
            }
            btnList.append(btn)
            btn.rx.tap.subscribe { _ in
                btnList.forEach { temp in
                    temp.isSelected = false
                    temp.titleLabel?.font = .systemFont(ofSize: 14)
                }
                btn.isSelected = true
                btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
                self.viewModel.currectIndex = i
                self.viewModel.loadData()
            }.disposed(by: disponseBag)
        }
        btnList[self.viewModel.currectIndex].isSelected = true
        btnList[self.viewModel.currectIndex].titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        
    }
    
    func listView() {
        let tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.backgroundColor = .bckColor
        tableView.snp.makeConstraints { make in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(UIDevice.NAV_HEIGHT+UIDevice.STATUS_HEIGHT+40)
        }
        tableView.rowHeight = 180
        tableView.separatorStyle = .none
        tableView.register(JSOrderListCell.self,forCellReuseIdentifier: JSOrderListCell.cellID)
        viewModel.tableView = tableView
        viewModel.orderList.asDriver().drive(tableView.rx.items){(tb,index,model) in
            let cell = tb.dequeueReusableCell(withIdentifier: JSOrderListCell.cellID) as! JSOrderListCell
            cell.model.accept(model)
            cell.callback = { _ in
                self.viewModel.loadData()
            }
            return cell
        }.disposed(by: disponseBag)
        
        
        
    }
}

// MARK: - JSOrderListCell


class JSOrderListCell:UITableViewCell {
    static let cellID = "JSOrderListCell"
    
    var callback: ((_ index: Int) -> ())? = nil
    
    let model = PublishRelay<JSOrderModel>()
    
    var orderModel:JSOrderModel?
    
    let dis = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        selectionStyle = .none
        let topLine = UIView()
        topLine.backgroundColor = .bckColor
        self.contentView.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.height.equalTo(8)
            make.top.equalTo(0)
        }
     
        let shopLb = UILabel()
        shopLb.text = "京东自营"
        shopLb.font = .boldSystemFont(ofSize: 15)
        shopLb.textColor = .black33
        self.contentView.addSubview(shopLb)
        shopLb.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(topLine.snp.bottom).offset(10)
        }
        
        let statusLb = UILabel()
        statusLb.text = "待支付"
        statusLb.font = .systemFont(ofSize: 15)
        statusLb.textColor = .black99
        self.contentView.addSubview(statusLb)
        statusLb.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.top.equalTo(topLine.snp.bottom).offset(10)
        }
        
        let image1 = UIImageView()
      
        self.contentView.addSubview(image1)
        image1.snp.makeConstraints { make in
            make.top.equalTo(shopLb.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalTo(75)
            make.height.equalTo(75)
        }
        
        let image2 = UIImageView()
       
        self.contentView.addSubview(image2)
        image2.snp.makeConstraints { make in
            make.top.equalTo(shopLb.snp.bottom).offset(10)
            make.left.equalTo(image1.snp.right).offset(8)
            make.width.equalTo(75)
            make.height.equalTo(75)
        }
        
        let image3 = UIImageView()

        self.contentView.addSubview(image3)
        image3.snp.makeConstraints { make in
            make.top.equalTo(shopLb.snp.bottom).offset(10)
            make.left.equalTo(image2.snp.right).offset(8)
            make.width.equalTo(75)
            make.height.equalTo(75)
        }
        
        let priceLb = UILabel()
        priceLb.text = "¥110.21"
        priceLb.textColor = .black
        priceLb.font = .systemFont(ofSize: 15)
        self.contentView.addSubview(priceLb)
        priceLb.snp.makeConstraints { make in
            make.centerY.equalTo(image1).offset(-10)
            make.right.equalTo(-10)
        }
        
        let countLb = UILabel()
        countLb.text = "¥110.21"
        countLb.textColor = .gray
        countLb.font = .systemFont(ofSize: 15)
        self.contentView.addSubview(countLb)
        countLb.snp.makeConstraints { make in
            make.centerY.equalTo(image1).offset(10)
            make.right.equalTo(-10)
        }
        
        var itemList = Array<UIButton>()
        for _ in 0 ..< 4 {
            let btn = UIButton()
            self.contentView.addSubview(btn)
            btn.setTitle("", for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 13)
            btn.layer.borderColor = UIColor.black66.cgColor
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 13
            btn.setTitleColor(.black66, for: .normal)
            btn.snp.makeConstraints { make in
                if itemList.last != nil {
                    make.right.equalTo(itemList.last!.snp.left).offset(-5)
                } else {
                    make.right.equalTo(-10)
                }
                make.top.equalTo(image1.snp.bottom).offset(18)
                make.height.equalTo(26)
            }
            btn.addTarget(self, action: #selector(itemAction(btn: )), for: .touchUpInside)
           
            itemList.append(btn)
        }
        
        model.subscribe { ele in
            let model = ele.element!
            self.orderModel = model
            priceLb.text = model.price
            let goods = try! JSONSerialization.jsonObject(with: model.goods.data(using: .utf8)!)
            self.images(goods: goods,img1: image1,img2: image2,img3: image3,count: countLb)
            self.setStatus(model: model, label: statusLb)
            self.setMenuItem(list: itemList,model: model)
            
        }.disposed(by: dis)
        
        
    }
    
    
    
    func images(goods:Any,img1:UIImageView,img2:UIImageView,img3:UIImageView,count:UILabel) {
        let imgs = [img1,img2,img3]
        
        let arr = goods as! Array<Dictionary<String, Any>>
        let list = Array<JSShopCarModel>.deserialize(from: arr) as! Array<JSShopCarModel>
        var allCount = 0
        for i in 0 ..< imgs.count {
            if(list.count > i) {
                allCount += list.count
                imgs[i].kf.setImage(with: URL(string: list[i].goodsImg ?? ""))
            } else {
                imgs[i].image = nil
            }
        }
        count.text = "共\(allCount)件"
        
        
    }
    
    func setStatus(model:JSOrderModel,label:UILabel) {
        var title = ""
        if model.state == -1 {
            title = "已取消"
        }
        if model.state==0 {
            title = "待支付"
        }
        if model.state==1 {
            title = "待发货"
        }
        if model.state==2 {
            title = "待收货"
        }
        if model.state==3 {
            title = model.content.count==0 ? "待评价" : "已完成"
        }
        label.text = title
    }
    
    func setMenuItem(list:Array<UIButton>,model:JSOrderModel) {
        list.forEach { btn in
            btn.isHidden = true
        }
        if model.state==0 {
            list[0].isHidden = false
            list[0].setTitle("  去支付  ", for:.normal)
            list[1].isHidden = false
            list[1].setTitle("  取消订单  ", for:.normal)
        }
        if model.state==1 {
            list[0].isHidden = false
            list[0].setTitle("  去发货  ", for:.normal)
            list[1].isHidden = false
            list[1].setTitle("  催发货  ", for:.normal)
        }
        if model.state==2 {
            list[0].isHidden = false
            list[0].setTitle("  确认收货  ", for:.normal)
            list[1].isHidden = false
            list[1].setTitle("  查看物流  ", for:.normal)
        }
        
        if model.state==3 {
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
                self.callback?(0)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                
                    
            }))
            alert.addTextField { tf in
                tf.isSecureTextEntry = true
                tf.keyboardType = .numberPad
            }
            self.viewContainingController()?.present(alert, animated: true)
            break
        case "  去发货  ":
            let alert = UIAlertController(title: "输入快递单号", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                self.orderModel?.state = 2
                self.orderModel?.expressTime = String.newTime()
                self.orderModel?.expressNumber = alert.textFields?.first?.text ?? ""
                JSOrderModel.updateModel(model: self.orderModel!)
                Toasts.showInfo(tip: "发货成功")
                self.callback?(0)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
               
                    
            }))
            alert.addTextField { tf in
                tf.keyboardType = .numberPad
            }
            self.viewContainingController()?.present(alert, animated: true)
            
            break
            
        case "  确认收货  ":
            let alert = UIAlertController(title: "是否确认收货", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                self.orderModel?.state = 3
                self.orderModel?.endTime = String.newTime()
                JSOrderModel.updateModel(model: self.orderModel!)
                Toasts.showInfo(tip: "确认收货成功")
                self.callback?(0)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
               
                    
            }))

            self.viewContainingController()?.present(alert, animated: true)
            
            break
        case "  去评价  ":
            let alert = UIAlertController(title: "评论", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                self.orderModel?.content = alert.textFields?.first?.text ?? ""
                JSOrderModel.updateModel(model: self.orderModel!)
                Toasts.showInfo(tip: "评论成功")
                self.callback?(0)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
               
                    
            }))
            alert.addTextField { tf in
                tf.keyboardType = .numberPad
                tf.placeholder = "请输入评论"
            }
            self.viewContainingController()?.present(alert, animated: true)
            
            break
            
        case "  取消订单  ":
            
            
            break
            
            
            
        default:
            break
        }
        
        
    }
    
    
    
}

//
//  JSEditAddressViewController.swift
//  shop
//
//  Created by zyjz on 2023/11/27.
//

import UIKit
import RxSwift

class JSEditAddressViewController: JSBaseViewController {
    
    let disposeBag = DisposeBag()
    open var editModel:JSAddressModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      setUI()
        
        
    }

  
    func setUI() {
        
        if(editModel != nil){
            self.navigationItem.rightBarButtonItem = NavbarTool.barButtonItem(bag: disposeBag, title: "删除地址", callBack: {
                JSAddressModel.deleteModel(model: self.editModel!)
                Toasts.showInfo(tip: "删除成功")
                self.navigationController?.popViewController(animated: true)
            })
        }
        
        self.view.backgroundColor = .bckColor
        let topView = UIView()
        topView.backgroundColor = .white
        topView.layer.cornerRadius = 8
        self.view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(UIDevice.NAV_HEIGHT+UIDevice.STATUS_HEIGHT+10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(180)
        }
        
        let titleArray = ["收货人","电话号码","所在地区","详细地址"]
        for i in 0..<titleArray.count {
            let label = UILabel()
            label.text = titleArray[i]
            label.font = .boldSystemFont(ofSize: 14)
            label.textColor = .black
           
            topView.addSubview(label)
            label.snp.makeConstraints { make in
                make.top.equalTo(i*40)
                make.left.equalTo(10)
                make.height.equalTo(40)
                make.width.equalTo(70)
            }
            if(i != titleArray.count-1){
                let line = UIView()
                line.backgroundColor = .bckColor
                topView.addSubview(line)
                line.snp.makeConstraints { make in
                    make.height.equalTo(0.5)
                    make.left.right.equalTo(0)
                    make.top.equalTo(label.snp.bottom).offset(0)
                }
            }
        }
        
        let nameTf = UITextField()
        nameTf.placeholder = "输入收货人姓名"
        nameTf.font = .systemFont(ofSize: 14)
        topView.addSubview(nameTf)
        nameTf.snp.makeConstraints { make in
            make.left.equalTo(85)
            make.height.equalTo(40)
            make.right.equalTo(-10)
            make.top.equalTo(0)
        }
        let phoneTf = UITextField()
        phoneTf.placeholder = "输入手机号码"
        phoneTf.keyboardType = .numberPad
        phoneTf.font = .systemFont(ofSize: 14)
        topView.addSubview(phoneTf)
        phoneTf.snp.makeConstraints { make in
            make.left.equalTo(nameTf)
            make.height.equalTo(40)
            make.right.equalTo(-10)
            make.top.equalTo(40*1)
        }
        
        let selectAddressBtn = UIButton(type: .custom)
        selectAddressBtn.setTitle("请选择地区", for: .normal)
        selectAddressBtn.contentHorizontalAlignment = .left
        selectAddressBtn.titleLabel?.font = .systemFont(ofSize: 14)
        selectAddressBtn.setTitleColor(.hexColor(rgbValue: 0xcccccc), for: .normal)
        selectAddressBtn.setTitleColor(.black, for: .selected)
        topView.addSubview(selectAddressBtn)
        selectAddressBtn.snp.makeConstraints { make in
            make.left.equalTo(nameTf)
            make.height.equalTo(40)
            make.right.equalTo(-10)
            make.top.equalTo(40*2)
        }
        
        let detailTf = UITextView()
        detailTf.font = .systemFont(ofSize: 14)
        topView.addSubview(detailTf)
        detailTf.snp.makeConstraints { make in
            make.left.equalTo(nameTf)
            make.right.equalTo(-10)
            make.top.equalTo(40*3+3)
            make.bottom.equalTo(-5)
        }
        
        let placeLb = UILabel()
        placeLb.font = .systemFont(ofSize: 14)
        placeLb.text = "请输入详细地址"
        placeLb.textColor = .hexColor(rgbValue: 0xcccccc)
        detailTf.addSubview(placeLb)
        placeLb.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(7)
        }
        
        detailTf.rx.didChange.subscribe { _ in
            if(detailTf.text.isEmpty){
                placeLb.isHidden = false
            } else {
                placeLb.isHidden = true
            }
        }.disposed(by: disposeBag)
        
        
        selectAddressBtn.rx.tap.subscribe { _ in
            let selectViews = JSAddressPicker(frame: self.view.bounds)
            self.view.addSubview(selectViews)
            selectViews.callBack = {a in
                selectAddressBtn.isSelected = true
                selectAddressBtn.setTitle(a.title, for: .selected)
            }
        }.disposed(by: disposeBag)
        
        
        
        let defaultView = UIView()
        defaultView.backgroundColor = .white
        defaultView.layer.cornerRadius = 8
        self.view.addSubview(defaultView)
        defaultView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(60)
        }
        
        let defaultTitle = UILabel()
        defaultTitle.text = "设置默认地址"
        defaultTitle.font = .systemFont(ofSize: 16)
        defaultTitle.textColor = .black
        defaultView.addSubview(defaultTitle)
        defaultTitle.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.left.equalTo(10)
            make.height.equalTo(30)
        }
        let defaultDes = UILabel()
        defaultDes.text = "提示：下单会优先使用该地址"
        defaultDes.font = .systemFont(ofSize: 12)
        defaultDes.textColor = .hexColor(rgbValue: 0x999999)
        defaultView.addSubview(defaultDes)
        defaultDes.snp.makeConstraints { make in
            make.top.equalTo(35)
            make.left.equalTo(10)
            make.height.equalTo(20)
        }
        
        let defaultBtn = UISwitch()
        defaultView.addSubview(defaultBtn)
        defaultBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-14)
        }
        
        let addBtn = UIButton(type: .custom)
        addBtn.setTitle("确定", for: .normal)
        addBtn.setTitleColor(.white, for: .normal)
        addBtn.backgroundColor = .red
        addBtn.layer.cornerRadius = 15
        addBtn.titleLabel?.font = .systemFont(ofSize: 16)
        
        self.view.addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.top.equalTo(defaultView.snp.bottom).offset((25.0))
            make.height.equalTo(40)
        }
        addBtn.rx.tap.subscribe { _ in
          
            self.saveAddress(name: nameTf.text, phone: phoneTf.text, adddress: selectAddressBtn.currentTitle, detailAddress: detailTf.text, defalult: defaultBtn.isOn)
            
        }.disposed(by: disposeBag)
        
        if(editModel != nil) {
            self.title = "编辑地址"
            nameTf.text = editModel?.userName
            phoneTf.text = editModel?.phone
            selectAddressBtn.setTitle(editModel?.address, for: .selected)
            selectAddressBtn.isSelected = true
            detailTf.text = editModel?.addressDetail
            placeLb.isHidden = true
            defaultBtn.isOn = editModel?.defaultFlag ?? false
        }else{
            self.title = "新增地址"
        }
        
    }
    
    func saveAddress(name:String?,phone:String?,adddress:String?,detailAddress:String?,defalult:Bool) {
        if(editModel != nil) {
            editModel!.userId = UserInfo.share.user.id ?? 0
            editModel!.userName = name ?? ""
            editModel!.phone = phone ?? ""
            editModel!.address = adddress ?? ""
            editModel!.addressDetail = detailAddress ?? ""
            editModel!.defaultFlag = defalult
            JSAddressModel.updateModel(model: editModel!)
        }else{
            let model = JSAddressModel()
            model.userId = UserInfo.share.user.id ?? 0
            model.userName = name ?? ""
            model.phone = phone ?? ""
            model.address = adddress ?? ""
            model.addressDetail = detailAddress ?? ""
            model.defaultFlag = defalult
            model.saveModel()
        }
        self.navigationController?.popViewController(animated: true)
    }
  

}

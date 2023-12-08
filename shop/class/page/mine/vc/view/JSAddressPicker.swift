//
//  JSAddressPicker.swift
//  shop
//
//  Created by zyjz on 2023/11/28.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
typealias BlockWithParameters<T> = (T) -> ()
class JSAddressPicker: UIView {
    
    var callBack: BlockWithParameters<(title: String, code: String)>? = nil
    
    var addressModel = SelectAddressModel();
    
    let tableList = BehaviorRelay<[AddressTownModel]>(value:[])
    
    let disposeBag = DisposeBag()
    
    var provinceModel = AddressTownModel()
    var cityModel = AddressTownModel()
    var areaModel = AddressTownModel()
    var townModel = AddressTownModel()
    
    let stepIndex = BehaviorRelay<Int>(value:0)
    
    var selectIndex = -1
    
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        let bck = UIButton(type: .custom)
        addSubview(bck)
        bck.addTarget(self, action: #selector(remove), for: .touchUpInside)
        bck.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        bck.frame = self.bounds
        
        let conView = UIView()
        addSubview(conView)
        conView.layer.cornerRadius = 10
        conView.backgroundColor = .white
        conView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(self.frame.size.height*0.66)
        }
        let titleLb = UILabel()
        titleLb.text = "请选择"
        titleLb.textColor = .gray
        conView.addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(8)
        }
        
        let ensureBtn = UIButton()
        ensureBtn.setTitleColor(.hexColor(rgbValue: 0x0053E7), for: .normal)
        ensureBtn.setTitle("确定", for: .normal)
        ensureBtn.titleLabel?.font = .systemFont(ofSize: 15)
        conView.addSubview(ensureBtn)
        ensureBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLb)
            make.height.equalTo(30)
            make.right.equalTo(-12)
        }
        ensureBtn.rx.tap.subscribe { _ in
            let address = self.provinceModel.townName+self.cityModel.townName+self.areaModel.townName+self.townModel.townName
            let addressCode = "\(self.provinceModel.townId)-\(self.cityModel.townId)-\(self.areaModel.townId)-\(self.townModel.townId)"
            self.callBack?((address,addressCode))
            self.remove()
        }.disposed(by: disposeBag)
        
        let selectVIew = UIView()
        conView.addSubview(selectVIew)
        selectVIew.snp.makeConstraints { make in
            make.top.equalTo(titleLb.snp.bottom).offset(8)
            make.left.right.equalTo(0)
            make.height.equalTo(40)
        }
        
        let provinceBtn = UIButton()
        provinceBtn.setTitleColor(.red, for: .selected)
        provinceBtn.setTitleColor(.black, for: .normal)
        provinceBtn.isSelected = true
        provinceBtn.titleLabel?.font = .systemFont(ofSize: 13)
        selectVIew.addSubview(provinceBtn)
        provinceBtn.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
 
        let cityBtn = UIButton()
        cityBtn.setTitleColor(.red, for: .selected)
        cityBtn.setTitleColor(.black, for: .normal)
        cityBtn.isSelected = true
        cityBtn.titleLabel?.font = .systemFont(ofSize: 13)
        selectVIew.addSubview(cityBtn)
        cityBtn.snp.makeConstraints { make in
            make.left.equalTo(provinceBtn.snp.right).offset(0)
            make.centerY.equalToSuperview()
        }
        
        let areaBtn = UIButton()
        areaBtn.setTitleColor(.red, for: .selected)
        areaBtn.setTitleColor(.black, for: .normal)
        areaBtn.isSelected = true
        areaBtn.titleLabel?.font = .systemFont(ofSize: 13)
        selectVIew.addSubview(areaBtn)
        areaBtn.snp.makeConstraints { make in
            make.left.equalTo(cityBtn.snp.right).offset(0)
            make.centerY.equalToSuperview()
        }
        
        let townBtn = UIButton()
        townBtn.setTitleColor(.red, for: .selected)
        townBtn.setTitleColor(.black, for: .normal)
        townBtn.isSelected = true
        townBtn.titleLabel?.font = .systemFont(ofSize: 13)
        selectVIew.addSubview(townBtn)
        townBtn.snp.makeConstraints { make in
            make.left.equalTo(areaBtn.snp.right).offset(0)
            make.centerY.equalToSuperview()
        }
        
        
        stepIndex.asDriver().drive { idx in
            if(idx == 0) {
                provinceBtn.isSelected = true
                provinceBtn.setTitle(" 请选择 ", for: .normal)
            }
            
            if(idx == 1) {
                provinceBtn.isSelected = false
                cityBtn.isSelected = true
                provinceBtn.setTitle(" \(self.provinceModel.townName) ", for: .selected)
                provinceBtn.setTitle(" \(self.provinceModel.townName) ", for: .normal)
                cityBtn.setTitle(" 请选择 ", for: .selected)
            }
            if(idx == 2) {
                cityBtn.isSelected = false
                areaBtn.isSelected = true
                cityBtn.setTitle(" \(self.cityModel.townName) ", for: .selected)
                cityBtn.setTitle(" \(self.cityModel.townName) ", for: .normal)
                areaBtn.setTitle(" 请选择 ", for: .selected)
            }
            if(idx == 3) {
                areaBtn.isSelected = false
                townBtn.isSelected = true
                areaBtn.setTitle(" \(self.areaModel.townName) ", for: .selected)
                areaBtn.setTitle(" \(self.areaModel.townName) ", for: .normal)
                townBtn.setTitle(" 请选择 ", for: .selected)
            }
            if(idx == 4) {
                townBtn.isSelected = true
                townBtn.setTitle(" \(self.townModel.townName) ", for: .selected)
                townBtn.setTitle(" \(self.townModel.townName) ", for: .normal)
                
            }
        }.disposed(by:disposeBag)
        
        let lines = UIView()
        lines.backgroundColor = .bckColor
        selectVIew.addSubview(lines)
        lines.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(1)
        }

        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = 35
        tableView.register(SelectAddressCell.self,forCellReuseIdentifier: "UITableViewCell")
        conView.addSubview(tableView);
        tableView.snp.makeConstraints { make in
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
            make.top.equalTo(selectVIew.snp.bottom).offset(0)
        }

        tableList.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell:SelectAddressCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") as! SelectAddressCell
                cell.addressLabel?.text = element.townName
            if(row == self.selectIndex) {
                cell.addressLabel?.textColor = .red
            } else {
                cell.addressLabel?.textColor = .hexColor(rgbValue: 0x333333)
            }
            
              return cell
            }
            .disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe { indexPath in
            self.selectIndex = -1
            let index = self.stepIndex.value
            if(index == 0) {
                self.provinceModel = self.tableList.value[indexPath.element!.row]
                self.stepIndex.accept(1)
                var list = Array<AddressTownModel>()
                let dataList = self.addressModel.list[indexPath.element!.row].cityList
                for index in 0..<dataList.count {
                    var add = AddressTownModel()
                    add.townName = dataList[index].cityName
                    add.townId = dataList[index].cityId
                    add.index = index
                    list.append(add)
                }
                self.tableList.accept(list)
            }
            if(index == 1) {
                self.cityModel = self.tableList.value[indexPath.element!.row]
                self.stepIndex.accept(2)
                var list = Array<AddressTownModel>()
                let dataList = self.addressModel.list[self.provinceModel.index].cityList[indexPath.element!.row].areaList
                for index in 0..<dataList.count {
                    var add = AddressTownModel()
                    add.townName = dataList[index].areaName
                    add.townId = dataList[index].areaId
                    add.index = index
                    list.append(add)
                }
                self.tableList.accept(list)
                
            }
            if(index == 2) {
                self.areaModel = self.tableList.value[indexPath.element!.row]
                self.stepIndex.accept(3)
                var list = Array<AddressTownModel>()
                let dataList = self.addressModel.list[self.provinceModel.index].cityList[self.cityModel.index].areaList[indexPath.element!.row].townList
                for index in 0..<dataList.count {
                    var add = AddressTownModel()
                    add.townName = dataList[index].townName
                    add.townId = dataList[index].townId
                    add.index = index
                    list.append(add)
                }
                self.tableList.accept(list)
            }
            if(index == 3){
                self.townModel = self.tableList.value[indexPath.element!.row]
                self.stepIndex.accept(4)
            }
            if(index == 4){
                self.townModel = self.tableList.value[indexPath.element!.row]
                self.stepIndex.accept(4)
            }
            
            
        }.disposed(by: disposeBag)
        
        provinceBtn.rx.tap.subscribe { _ in
            self.stepIndex.accept(0)
            cityBtn.setTitle("", for: .normal)
            cityBtn.setTitle("", for: .selected)
            areaBtn.setTitle("", for: .normal)
            areaBtn.setTitle("", for: .selected)
            townBtn.setTitle("", for: .normal)
            townBtn.setTitle("", for: .selected)
            var list = Array<AddressTownModel>()
            for index in 0..<self.addressModel.list.count {
                var add = AddressTownModel()
                add.townName = self.addressModel.list[index].provinceName
                add.townId = self.addressModel.list[index].provinceId
                add.index = index
                list.append(add)
            }
            self.tableList.accept(list)
            self.selectIndex = -1
            if(!self.provinceModel.townName.isEmpty) {
                tableView.scrollToRow(at: IndexPath(row: self.provinceModel.index, section: 0), at: .middle, animated: true)
                self.selectIndex = self.provinceModel.index
                tableView.reloadData()
            }
            
        }.disposed(by: disposeBag)
        
        cityBtn.rx.tap.subscribe { _ in
            self.stepIndex.accept(1)
            areaBtn.setTitle("", for: .normal)
            areaBtn.setTitle("", for: .selected)
            townBtn.setTitle("", for: .normal)
            townBtn.setTitle("", for: .selected)
            var list = Array<AddressTownModel>()
            let dataList = self.addressModel.list[self.provinceModel.index].cityList
            for index in 0..<dataList.count {
                var add = AddressTownModel()
                add.townName = dataList[index].cityName
                add.townId = dataList[index].cityId
                add.index = index
                list.append(add)
            }
            self.tableList.accept(list)
            self.selectIndex = -1
            if(!self.cityModel.townName.isEmpty) {
                tableView.scrollToRow(at: IndexPath(row: self.cityModel.index, section: 0), at: .middle, animated: true)
                self.selectIndex = self.cityModel.index
                tableView.reloadData()
            }
            
        }.disposed(by: disposeBag)
        
        areaBtn.rx.tap.subscribe { _ in
            self.stepIndex.accept(2)
            townBtn.setTitle("", for: .normal)
            townBtn.setTitle("", for: .selected)
            var list = Array<AddressTownModel>()
            let dataList = self.addressModel.list[self.provinceModel.index].cityList[self.cityModel.index].areaList
            for index in 0..<dataList.count {
                var add = AddressTownModel()
                add.townName = dataList[index].areaName
                add.townId = dataList[index].areaId
                add.index = index
                list.append(add)
            }
            self.tableList.accept(list)
            self.selectIndex = -1
            if(!self.areaModel.townName.isEmpty) {
                tableView.scrollToRow(at: IndexPath(row: self.areaModel.index, section: 0), at: .middle, animated: true)
                self.selectIndex = self.areaModel.index
                tableView.reloadData()
            }
            
        }.disposed(by: disposeBag)
        
        
        getAddressModel()
    }
    
    func getAddressModel() {
        let path = Bundle.main.path(forResource: "city_data", ofType: "json")
        let data = FileManager.default.contents(atPath: path!)
        let json:Any = try! JSONSerialization.jsonObject(with: data!, options: [])
        addressModel = SelectAddressModel.deserialize(from: json as? Dictionary<String, Any>) ?? SelectAddressModel()
        
        var list = Array<AddressTownModel>()
        for index in 0..<addressModel.list.count {
            var add = AddressTownModel()
            add.townName = addressModel.list[index].provinceName
            add.townId = addressModel.list[index].provinceId
            add.index = index
            list.append(add)
        }
        tableList.accept(list)
    }
    
    
    
    @objc func remove() {
        self.removeFromSuperview()
    }
    
}

class SelectAddressCell:UITableViewCell {
    
    var addressLabel:UILabel?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        addressLabel = UILabel()
        addressLabel?.textColor = .hexColor(rgbValue: 0x333333)
        addressLabel?.font = .systemFont(ofSize: 14)
        self.contentView.addSubview(addressLabel!)
        addressLabel?.snp.makeConstraints({ make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        })
        
        
        selectionStyle = .none
    }
    
    
}

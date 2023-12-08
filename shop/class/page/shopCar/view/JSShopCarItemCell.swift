//
//  JSShopCarItemCell.swift
//  shop
//
//  Created by zyjz on 2023/11/20.
//

import UIKit
import RxSwift

class JSShopCarItemCell: UITableViewCell {

    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var goodImg: UIImageView!
    
    
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var priceLb: UILabel!
    
    @IBOutlet weak var countTf: UITextField!
    
    var models:JSShopCarModel?
    var viewModel:JSShopCarViewModel?
    
    func setModel(model:JSShopCarModel,viewModels:JSShopCarViewModel){
        models = model
        viewModel = viewModels
        goodImg.kf.setImage(with: URL(string: model.goodsImg ?? ""))
        titleLb.text = model.goodsName
        priceLb.text = model.goodsPrice
        countTf.text = "\(model.count!)"
        if (model.selectFlag != nil) {
            selectBtn.isSelected = model.selectFlag!==1
        } else{
            selectBtn.isSelected = false
        }
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        if sender.isSelected {
            models!.selectFlag = 0
        } else {
            models!.selectFlag = 1
        }
        JSShopCarModel.updateModel(model: models!)
        (self.superview as! UITableView).reloadData()
        viewModel!.countPrice()
    }
    
   
    @IBAction func reduceCountAction(_ sender: Any) {
        models!.count! -= 1
        if models!.count! <= 0 {
            models?.count = 1
        }
        JSShopCarModel.updateModel(model: models!)
        (self.superview as! UITableView).reloadData()
        viewModel!.countPrice()
    }
    
    
    @IBAction func addCountAction(_ sender: Any) {
        models!.count! += 1
        JSShopCarModel.updateModel(model: models!)
        (self.superview as! UITableView).reloadData()
        viewModel!.countPrice()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectBtn.setBackgroundImage(R.image.icon_shop_car_un_select(), for: .normal)
        selectBtn.setBackgroundImage(R.image.icon_shop_car_select(), for: .selected)
        
        countTf.addTarget(self,action: #selector(countTfEnd(_:)), for: .editingDidEnd)
    }
    
    
    @objc func countTfEnd(_ tf:UITextField){
        let count = Int(tf.text!)
        if (count != nil){
            models!.count! = count!
        } else{
            models!.count! = 1
        }
        JSShopCarModel.updateModel(model: models!)
        (self.superview as! UITableView).reloadData()
        viewModel!.countPrice()
        setSelected(false, animated: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

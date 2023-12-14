//
//  CatrgoryCell.swift
//  shop
//
//  Created by zyjz on 2023/11/7.
//

import UIKit

class JSCatrgoryCell: UITableViewCell {

    lazy var model = GoodsModel()
    
    @IBOutlet weak var addShopCar: UIImageView!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var price: UILabel!
    
    func setModel(model:GoodsModel){
        self.model = model
        img.kf.setImage(with: URL(string: model.goodsImg))
        name.text = model.goodsName
        price.text = "¥\(Double(model.goodsPrice) ?? 0.0)"
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        addShopCar.isUserInteractionEnabled = true
        addShopCar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addShopcarAction)))
        
    }

    @objc func addShopcarAction() {
        JSShopCarModel.savelModel(model: model)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

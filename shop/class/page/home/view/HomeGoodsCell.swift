//
//  HomeGoodsCell.swift
//  shop
//
//  Created by zyjz on 2023/11/6.
//

import UIKit

class HomeGoodsCell: UICollectionViewCell {

    lazy var model = GoodsModel()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var priceLb: UILabel!
    
    func setModel(model:GoodsModel){
        self.model = model
        imageView.kf.setImage(with: URL(string: model.goodsImg))
        titleLb.text = model.goodsName
        
        
    }
  
    @IBAction func addShopcat(_ sender: UIButton) {
        JSShopCarModel.savelModel(model: model)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        self.layer.cornerRadius = 10
        // Initialization code
    }

}

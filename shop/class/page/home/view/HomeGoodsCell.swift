//
//  HomeGoodsCell.swift
//  shop
//
//  Created by zyjz on 2023/11/6.
//

import UIKit

class HomeGoodsCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var priceLb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        self.layer.cornerRadius = 10
        // Initialization code
    }

}

//
//  JSBannerCell.swift
//  shop
//
//  Created by zyjz on 2023/12/8.
//

import UIKit
import FSPagerView

class JSBannerCell: FSPagerViewCell {
    
    
    var images:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        images = UIImageView()
        self.contentView.addSubview(images!)
        images!.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(0)
        }
    }
    
    
}

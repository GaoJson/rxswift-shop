//
//  scrollviewTool.swift
//  shop
//
//  Created by zyjz on 2023/12/13.
//

import Foundation
import UIKit


extension UIScrollView {
    private static var NO_DATA_KEY = false
    var noData: UIView? {
                get {
                    var exist = objc_getAssociatedObject(self, &Self.NO_DATA_KEY) as? UIView
                    if (exist == nil) {
                        let view = UIView()
                        self.addSubview(view)
                        
                        view.snp.makeConstraints { make in
                            make.width.equalToSuperview()
                            make.height.equalToSuperview().multipliedBy(0.5)
                            make.center.equalToSuperview()
                        }
                        let img = UIImageView()
                        img.image = R.image.icon_data_empty()
                        img.sizeToFit()
                        view.addSubview(img)
                        img.snp.makeConstraints { make in
                            make.top.equalTo(0)
                            make.centerX.equalToSuperview()
                            make.width.equalToSuperview().multipliedBy(0.8)
                            make.height.equalTo(img.snp.width).multipliedBy(0.61);
                        }
                        
                        let label = UILabel()
                        label.text = "暂无数据"
                        label.textColor = .black99
                        label.font = .systemFont(ofSize: 15)
                        view.addSubview(label)
                        label.snp.makeConstraints { make in
                            make.centerX.equalToSuperview()
                            make.top.equalTo(img.snp.bottom).offset(8)
                        }
                        exist = view
                        objc_setAssociatedObject(self, &Self.NO_DATA_KEY, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    }
                   return exist
                }
               
        }
    
    
}

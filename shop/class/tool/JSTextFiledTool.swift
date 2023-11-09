//
//  JSTextFiledTool.swift
//  shop
//
//  Created by zyjz on 2023/11/8.
//

import Foundation
import UIKit


extension UITextField {
    
     func leftImage(image:UIImage?) {
       
         let leftView = UIImageView()
         leftView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
         leftView.image = image
         let view = UIView()
         view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
         view.addSubview(leftView)
        self.leftView = view
        self.leftViewMode = .always
    }
    
    
}

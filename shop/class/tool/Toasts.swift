//
//  Toasts.swift
//  shop
//
//  Created by zyjz on 2023/11/9.
//

import Foundation
import ZKProgressHUD

class Toasts {
    
    static func showInfo(tip:String) {
        ZKProgressHUD.showInfo(tip,maskStyle: .hide)
    }
    
    
}

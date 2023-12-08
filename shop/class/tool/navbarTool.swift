//
//  navbarTool.swift
//  shop
//
//  Created by zyjz on 2023/11/16.
//

import Foundation
import UIKit
import RxSwift

class NavbarTool {
    
    static func barButtonItem(bag:DisposeBag,images:UIImage,callBack:@escaping()->())->UIBarButtonItem {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        let imageV = UIButton()
        imageV.setImage(images, for: .normal)
        imageV.frame = CGRect(x: 7, y: 0, width: 23, height: 23)
        view.addSubview(imageV)
        imageV.rx.tap.subscribe(onNext: { _ in
            callBack()
        }).disposed(by: bag)
        return UIBarButtonItem(customView: view);
    }
    
    static func barButtonItem(bag:DisposeBag,title:String,callBack:@escaping()->())->UIBarButtonItem {
        let barBtn = UIBarButtonItem(title: title, style: .done, target: self, action: nil);
        barBtn.rx.tap.subscribe { _ in
          callBack()
        }.disposed(by:bag)
        return barBtn
    }
    
}

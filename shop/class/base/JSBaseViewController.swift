//
//  JSBaseViewController.swift
//  shop
//
//  Created by zyjz on 2023/11/10.
//

import UIKit

class JSBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = "";
        backItem.tintColor = .gray
        self.navigationItem.backBarButtonItem = backItem;
        self.view.backgroundColor = .bckColor
    }
    

 

}

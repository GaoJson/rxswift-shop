//
//  JSBaseNavViewController.swift
//  shop
//
//  Created by zyjz on 2023/11/10.
//

import UIKit

class JSBaseNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        super.pushViewController(viewController, animated: animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let top:UIViewController = self.topViewController ?? ViewController()
        return top.preferredStatusBarStyle
    }
  
    

}

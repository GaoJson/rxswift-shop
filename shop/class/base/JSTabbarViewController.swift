//
//  JSTabbarViewController.swift
//  shop
//
//  Created by zyjz on 2023/10/31.
//

import UIKit

class JSTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let view1 = UINavigationController(rootViewController: JSHomeViewController())
        view1.title = "123"
        view1.tabBarItem = UITabBarItem(title: "首页", image:R.image.ic_home_tab1_unchecked()?.withRenderingMode(.alwaysOriginal), selectedImage: R.image.icHomeTab1Selected()?.withRenderingMode(.alwaysOriginal))
        self.addChild(view1)
        
        let view2 = UINavigationController(rootViewController: JSCategoryViewController())
        view2.tabBarItem = UITabBarItem(title: "分类", image:R.image.ic_home_tab2_unchecked()?.withRenderingMode(.alwaysOriginal), selectedImage: R.image.ic_home_tab2_selected()?.withRenderingMode(.alwaysOriginal))
        self.addChild(view2)
        
        
    }
    


}

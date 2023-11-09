//
//  JSMineViewController.swift
//  shop
//
//  Created by zyjz on 2023/11/8.
//

import UIKit

class JSMineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = JSLoginViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated:true)
        
        
        
    }
    



}

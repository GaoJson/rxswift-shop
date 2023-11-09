//
//  JSRegistViewController.swift
//  shop
//
//  Created by zyjz on 2023/11/8.
//

import UIKit
import RxSwift
import ZKProgressHUD


typealias ChangeBlock = (String,String) -> ()

class JSRegistViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    var block:ChangeBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        let bckImg = UIImageView(image: R.image.login_bck())
        self.view.addSubview(bckImg)
        bckImg.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(0)
        }
        
        let passwordView = UITextField()
        passwordView.placeholder = "请输入密码"
        passwordView.borderStyle = .roundedRect
        passwordView.isSecureTextEntry = true
        passwordView.leftImage(image: R.image.icon_login_password())
        self.view.addSubview(passwordView)
        passwordView.snp.makeConstraints { make in
            make.centerY.equalTo(self.view)
            make.height.equalTo(40)
            make.left.equalTo(40)
            make.right.equalTo(-40)
        }
        
        let accountView = UITextField()
        accountView.placeholder = "请输入账号"
        accountView.borderStyle = .roundedRect
        accountView.leftImage(image: R.image.icon_login_account())
        self.view.addSubview(accountView)
        accountView.snp.makeConstraints { make in
            make.bottom.equalTo(passwordView.snp_topMargin).offset(-20)
            make.height.equalTo(40)
            make.left.equalTo(40)
            make.right.equalTo(-40)
        }
        
        let ensurePasswordView = UITextField()
        ensurePasswordView.isSecureTextEntry = true
        ensurePasswordView.placeholder = "请再次输入密码"
        ensurePasswordView.borderStyle = .roundedRect
        ensurePasswordView.leftImage(image: R.image.icon_login_password())
        self.view.addSubview(ensurePasswordView)
        ensurePasswordView.snp.makeConstraints { make in
            make.top.equalTo(passwordView.snp_bottomMargin).offset(20)
            make.height.equalTo(40)
            make.left.equalTo(40)
            make.right.equalTo(-40)
        }
        
        let loginBtn = UIButton(type: .custom)
        self.view.addSubview(loginBtn)
        loginBtn.setTitle("注册", for:.normal)
        loginBtn.backgroundColor = .orange
        loginBtn.layer.cornerRadius = 20
        
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(ensurePasswordView.snp_bottomMargin).offset(30)
            make.height.equalTo(45)
            make.left.equalTo(60)
            make.right.equalTo(-60)
        }
        
        loginBtn.rx.tap.subscribe { _ in
          let isExist =  JSUserModel.existAccount(userName: accountView.text!)
            if (isExist) {
                ZKProgressHUD.showInfo("用户已存在",maskStyle: .hide)
            } else {
                let user = JSUserModel()
                user.headIcon = ""
                user.password = passwordView.text
                user.userName = accountView.text
                user.save()
                ZKProgressHUD.showSuccess("注册成功！",maskStyle: .hide)
                self.block?(user.userName!,user.password!)
                
                self.dismiss(animated: true)
                
            }
        }.disposed(by: disposeBag)
        
    
        
    }
    
    

}

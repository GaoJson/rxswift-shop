//
//  JSLoginViewController.swift
//  shop
//
//  Created by zyjz on 2023/11/8.
//

import UIKit
import RxSwift
import RxCocoa

class JSLoginViewController: UIViewController {

    
    let disposeBag = DisposeBag()
    
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
        passwordView.isSecureTextEntry = true
        passwordView.borderStyle = .roundedRect
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
        
        let loginBtn = UIButton(type: .custom)
        self.view.addSubview(loginBtn)
        loginBtn.setTitle("登录", for:.normal)
        loginBtn.backgroundColor = .orange
        loginBtn.layer.cornerRadius = 20
        
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordView.snp_bottomMargin).offset(30)
            make.height.equalTo(45)
            make.left.equalTo(60)
            make.right.equalTo(-60)
        }
        
        loginBtn.rx.tap.subscribe{ _ in
          let userModel =  JSUserModel.loginAction(count: accountView.text!, pwd: passwordView.text!)
            if(userModel != nil) {
                Toasts.showInfo(tip: "登录成功")
                
            } else {
                Toasts.showInfo(tip: "账户或密码错误")
            }
        }.disposed(by: disposeBag)
        
    
        let rigistLb = UIButton(type: .custom)
        rigistLb.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rigistLb.setTitle("还没有账号，去注册！", for:.normal)
        rigistLb.setTitleColor(.white, for: .normal)
        self.view.addSubview(rigistLb)
        rigistLb.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(loginBtn.snp_bottomMargin).offset(40)
        }
        rigistLb.rx.tap.subscribe { _ in
            let vc = JSRegistViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.block = {str1,str2 in
                accountView.text = str1
                passwordView.text = str2
            }
            
            self.present(vc, animated: false)
        }.disposed(by: disposeBag)
        
    }
}

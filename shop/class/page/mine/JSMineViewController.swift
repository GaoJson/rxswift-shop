//
//  JSMineViewController.swift
//  shop
//
//  Created by zyjz on 2023/11/8.
//

import UIKit
import RxSwift
import RxDataSources

class JSMineViewController: UIViewController {

    let viewModel = JSMineViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
            // Fallback on earlier versions
        }
    }
        
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            let appear = UINavigationBarAppearance()
            appear.backgroundColor = .hexColor(rgbValue: 0x3476FF)
            appear.backgroundEffect = nil
            appear.shadowColor = .clear
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.scrollEdgeAppearance = appear
            self.navigationController?.navigationBar.standardAppearance = appear
        } else {
            // Fallback on earlier versions
        }
        if(UserInfo.share.isLogin){
            viewModel.userModel.accept(UserInfo.share.user)
        } else {
            viewModel.userModel.accept(JSUserModel())
        }
    }
    
    @objc func titleBarButtonItemMethod(){
        
    }
    
    func setUI(){
       
        
        self.navigationItem.rightBarButtonItems = [
            NavbarTool.barButtonItem(bag:disposeBag,images: R.image.icon_setting()!){
                
            },
            NavbarTool.barButtonItem(bag:disposeBag,images: R.image.icon_sever()!){
                debugPrint("11111")
            }
        ]
        
        
        let leftView = UITableView()
        leftView.register(UITableViewCell.self,forCellReuseIdentifier: "UITableViewCell")
        let bckView = UIView()
        let views = UIView()
        views.backgroundColor = .hexColor(rgbValue: 0x3476FF)
        views.frame = CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: 400)
        bckView.addSubview(views)
        leftView.addSubview(bckView)
        leftView.backgroundColor = .bckColor
        leftView.backgroundView = bckView
        self.view.addSubview(leftView)
        leftView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(UIDevice.BOTTOM_HEIGHT+UIDevice.TABBAR_HEIGHT)
            make.right.equalTo(0)
        }
        
        leftView.tableHeaderView = setTableHeadView()
    }
    
    func setTableHeadView()->UIView {
        let headView = UIView()
        headView.frame = CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: UIDevice.SCREEN_HEIGHT-90)
        setHeadInfo(view: headView)
        
        let contentView = UIView()
        headView.addSubview(contentView)
        contentView.backgroundColor = .bckColor
        contentView.layer.cornerRadius = 10;
        contentView.frame = CGRect(x: 0, y: 80, width: UIDevice.SCREEN_WIDTH, height: UIDevice.SCREEN_HEIGHT-180)
        
        
        let orderView = UIView()
        contentView.addSubview(orderView)
        orderView.backgroundColor = .white
        orderView.layer.cornerRadius = 10;
        orderView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(110)
        }
        setOrderView(views: orderView)
        
        
        let inviteImg = UIImageView()
        inviteImg.image = R.image.ic_my_invite()
        inviteImg.contentMode = .scaleAspectFit
        headView.addSubview(inviteImg)
        inviteImg.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.height.equalTo(309/1034*(UIDevice.SCREEN_WIDTH-20))
            make.top.equalTo(orderView.snp.bottom).offset(10)
        }
        
        
        let serviceView = UIView()
        headView.addSubview(serviceView)
        serviceView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(190)
            make.top.equalTo(inviteImg.snp.bottom).offset(10)
        }
        setServiceView(view: serviceView)
       
        return headView
    }
    
    func setHeadInfo(view:UIView){
        
        let userView = UIView()
        userView.backgroundColor = .hexColor(rgbValue: 0x3476FF)
        userView.frame = CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: 90)
        view.addSubview(userView)
        let headIcon = UIImageView()
        headIcon.kf.setImage(with: URL(string: "https://upload.jianshu.io/users/upload_avatars/6539412/69075f35-f3f1-4d33-b325-215d530b1620.jpg"))
        userView.addSubview(headIcon)
        headIcon.layer.cornerRadius = 8
        headIcon.layer.masksToBounds = true
        headIcon.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.leading.equalTo(20)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        let userName = UILabel()
        userName.text = "王思聪";
        userName.textColor = .white
        userView.addSubview(userName)
        userName.snp.makeConstraints { make in
            make.left.equalTo(headIcon.snp_rightMargin).offset(20)
            make.top.equalTo(headIcon).offset(0)
        }
        
        let mobile = UILabel()
        mobile.text = "18030***157";
        mobile.textColor = .white
        userView.addSubview(mobile)
        mobile.snp.makeConstraints { make in
            make.left.equalTo(headIcon.snp_rightMargin).offset(20)
            make.bottom.equalTo(headIcon).offset(0)
        }
        
        let arrow = UIImageView()
        userView.addSubview(arrow)
        arrow.image = R.image.icon_arrow_right_white()
        arrow.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalTo(headIcon)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        let loginBtn = UIButton(type: .custom)
        view.addSubview(loginBtn)
        loginBtn.frame = userView.frame
        loginBtn.backgroundColor = view.backgroundColor
        userView.isHidden = true
        loginBtn.rx.tap.subscribe { _ in
            self.present(JSLoginViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        let loginIcon = UIImageView()
        loginIcon.image = R.image.icon_my_defeatImg()
        loginBtn.addSubview(loginIcon)
        loginIcon.layer.cornerRadius = 8
        loginIcon.layer.masksToBounds = true
        loginIcon.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.leading.equalTo(20)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        let loginName = UILabel()
        loginName.text = "登录";
        loginName.textColor = .white
        loginBtn.addSubview(loginName)
        loginName.snp.makeConstraints { make in
            make.centerY.equalTo(loginIcon)
            make.left.equalTo(loginIcon.snp.right).offset(15)
        }
        
        viewModel.userModel.asObservable().subscribe{ e in
            if(e.element?.id != nil){
                loginBtn.isHidden = true
                userView.isHidden = false
                userName.text = e.element?.userName
                mobile.text = e.element?.userName
                
            } else {
                loginBtn.isHidden = false
                userView.isHidden = true
            }
        }.disposed(by: disposeBag)
        
        
        
    }
    
    
    func setOrderView(views:UIView) {
        let orderTitle = UILabel()
        orderTitle.text = "我的订单"
        orderTitle.textColor = .black
        views.addSubview(orderTitle)
        orderTitle.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.left.equalTo(12)
        }
        let orderArrow = UIImageView()
        orderArrow.image = R.image.icon_arrow_right_gray()
        views.addSubview(orderArrow)
        orderArrow.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.centerY.equalTo(orderTitle)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        let orderItem = ["待支付","待发货","已发货","待评价"]
        var badgeList = Array<UILabel>()
        for index in 0..<orderItem.count {
            let view = UIView()
            views.addSubview(view)
            view.snp.makeConstraints { make in
                make.bottom.equalTo(0)
                make.left.equalTo((Int(UIDevice.SCREEN_WIDTH)-20)/4*index)
                make.width.equalTo((UIDevice.SCREEN_WIDTH-20)/4.0)
                make.top.equalTo(40)
            }
            
            let icon = UIImageView()
            icon.image = UIImage(named: "ic_my_order_\(index+1)")
            view.addSubview(icon)
            icon.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-10)
                make.height.equalTo(23)
                make.width.equalTo(23)
            }
            let title = UILabel()
            title.text = orderItem[index]
            title.textColor = .black
            title.font = UIFont.systemFont(ofSize: 13)
            view.addSubview(title)
            title.snp.makeConstraints { make in
                make.top.equalTo(icon.snp.bottom).offset(5)
                make.centerX.equalToSuperview()
            }
            let badge = PaddingLabel()
            badge.text = "97"
            badge.textColor = .white
            badge.adjustsFontSizeToFitWidth = true;
            badge.textAlignment = .center
            badge.font = .systemFont(ofSize: 13)
            badge.layer.cornerRadius = 10
            badge.layer.masksToBounds = true
            badge.backgroundColor = .red
            views.addSubview(badge)
            badge.snp.makeConstraints { make in
                make.top.equalTo(icon).offset(-10)
                make.left.equalTo(icon.snp.right).offset(-5)
                make.height.equalTo(20)
                make.width.greaterThanOrEqualTo(20)
            }
            badgeList.append(badge)
        }
        
        
        
    }

    
    func setServiceView(view:UIView) {
        view.backgroundColor = .white
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = true
        let orderTitle = UILabel()
        orderTitle.text = "其他服务"
        orderTitle.textColor = .black
        view.addSubview(orderTitle)
        orderTitle.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.left.equalTo(12)
        }
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: (ScreenTool.SCREEN_WIDTH-20)/4, height: 75)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectView = UICollectionView(frame:CGRect(x: 0, y: 40, width: ScreenTool.SCREEN_WIDTH, height: 150) , collectionViewLayout: layout)
        collectView.register(CategoryCell.self,
                                             forCellWithReuseIdentifier: "Cell")
        view.addSubview(collectView)
        let list = Observable.just([
            "我的快递","我的快递","我的快递","我的快递","我的快递","我的快递","我的快递","我的快递"
        ])
        list.bind(to: collectView.rx.items) {(collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCell;
            cell.img?.image = UIImage(named: "ic_my_service_\(row+1)")
            cell.titleLabel?.text = element
            return cell
        }.disposed(by: disposeBag)
        
        
    }



}

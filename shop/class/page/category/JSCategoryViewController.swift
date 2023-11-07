//
//  JSCategoryViewController.swift
//  shop
//
//  Created by zyjz on 2023/11/7.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

class JSCategoryViewController: UIViewController {
    
    
    let viewModel = JSCatrgoryViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        viewModel.loadLeftData()
    }
    

    func setUI() {
        self.view.backgroundColor = .bckColor
        let leftView = UITableView()
        leftView.register(UITableViewCell.self,forCellReuseIdentifier: "UITableViewCell")
        leftView.backgroundColor = .bckColor
        self.view.addSubview(leftView)
        leftView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(UIDevice.SCREEN_WIDTH*0.25)
        }

        viewModel.leftList
            .bind(to: leftView.rx.items) { (tableView, row, element) in
              let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
                cell.textLabel?.text = "\(element.cname)"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
                cell.textLabel?.textAlignment = .center
              return cell
            }
            .disposed(by: disposeBag)
        
        
        let rightView = UITableView()
        rightView.backgroundColor = .bckColor
        
        
    }
    
    
    

}

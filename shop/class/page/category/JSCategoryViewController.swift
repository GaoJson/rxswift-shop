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
        self.title = "分类"
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
        rightView.rowHeight = 90
        rightView.register(UINib(nibName: "JSCatrgoryCell", bundle: nil),forCellReuseIdentifier: "UITableViewCell")
        self.view.addSubview(rightView)
        rightView.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.top.equalTo(UIDevice.STATUS_HEIGHT+UIDevice.NAV_HEIGHT)
            make.bottom.equalTo(0)
            make.width.equalTo(UIDevice.SCREEN_WIDTH*0.73)
        }
       
        viewModel.rightList.bind(to: rightView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") as! JSCatrgoryCell
            cell.img.kf.setImage(with: URL(string: element.goodsImg))
            cell.name.text = element.goodsName
            cell.price.text = "¥\(Double(element.goodsPrice) ?? 0.0)"
            return cell
        }
        .disposed(by: disposeBag)
        rightView.rx.itemSelected.subscribe{ index in
            rightView.deselectRow(at: index.element!, animated: true)
            
        }.disposed(by: disposeBag)
        
        
        rightView.es.addPullToRefresh { [weak self] in
            self?.viewModel.page = 1
            self?.viewModel.loadRightData(cid: self?.viewModel.cid ?? 0)
        }
        rightView.es.addInfiniteScrolling { [weak self] in
            self?.viewModel.page += 1
            self?.viewModel.loadRightData(cid: self?.viewModel.cid ?? 0)
        }
        
        viewModel.refreshStatus.asObservable().subscribe(onNext: { status in
            switch status {
            case .endHeaderRefresh:
                rightView.header?.stopRefreshing()
            case .endFooterRefresh:
                rightView.footer?.stopRefreshing()
            case .noMoreData:
                rightView.footer?.noticeNoMoreData()
            case .beingHeaderRefresh:
                leftView.selectRow(at: [0,0], animated: false, scrollPosition: .none)
            default:
                break
            }
        }
        ).disposed(by: disposeBag)
        
        leftView.rx.itemSelected.subscribe{ [self]indexPath in
            rightView.footer?.resetNoMoreData()
           let row =  indexPath.element?.row
           let model = viewModel.leftList.value[row ?? 0]
            viewModel.page = 1
            viewModel.loadRightData(cid: model.id)
        }.disposed(by: disposeBag)
        
    }
    
    
    

}

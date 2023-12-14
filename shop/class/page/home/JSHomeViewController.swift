//
//  JSHomeViewController.swift
//  shop
//
//  Created by zyjz on 2023/10/31.
//

import UIKit
import SnapKit
import ESPullToRefresh
import FSPagerView
import RxSwift
import RxCocoa
import RxDataSources
import WCDBSwift



class JSHomeViewController: JSBaseViewController {
    
    var viewModel = JSHomeViewModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        viewModel.loadTopData()
        viewModel.loadMoreData()
    }
    
    func setUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: ScreenTool.SCREEN_WIDTH/2-12, height: 250)
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 8
        layout.headerReferenceSize = CGSize(width: ScreenTool.SCREEN_WIDTH, height: 360)
        layout.sectionInset =  UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let collectView = UICollectionView(frame:CGRectZero, collectionViewLayout: layout)
        collectView.backgroundColor = .bckColor
        collectView.register(UINib(nibName: "HomeGoodsCell", bundle: nil), forCellWithReuseIdentifier: "HomeGoodsCell")
        collectView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeTop")
        collectView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeFoot")
        self.view.addSubview(collectView)
        collectView.snp.makeConstraints { make in
            make.top.equalTo(UIDevice.NAV_HEIGHT+UIDevice.STATUS_HEIGHT)
            make.bottom.equalTo(-(UIDevice.BOTTOM_HEIGHT+UIDevice.TABBAR_HEIGHT))
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        collectView.es.addPullToRefresh {
            self.viewModel.page = 1
            self.viewModel.loadTopData()
            self.viewModel.loadMoreData()
            
        }
        collectView.es.addInfiniteScrolling {
            self.viewModel.page += 1
            self.viewModel.loadMoreData()
        }
        
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String,GoodsModel>>(
            configureCell: { (ds, cv, indexPath, model) ->UICollectionViewCell in
                let cell:HomeGoodsCell = cv.dequeueReusableCell(withReuseIdentifier: "HomeGoodsCell", for: indexPath) as! HomeGoodsCell
                cell.setModel(model: model)
                return cell
            }, configureSupplementaryView: { (ds, cv, str, indexPath) ->UICollectionReusableView in
                
                if str == UICollectionView.elementKindSectionHeader {
                    let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeTop", for: indexPath)
                    if(view.subviews.count == 0) {
                        let topView = JSHomeTopView(frame: CGRect(x: 0, y: 0, width: ScreenTool.SCREEN_WIDTH, height: 350), viewModel: self.viewModel)
                        view.addSubview(topView)
                    }
                    return view
                }
                else if str == UICollectionView.elementKindSectionFooter {
                    let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeFoot", for: indexPath)
                    return view
                }
                return UICollectionReusableView()
            }
        )
        viewModel.refreshStatus.asObservable().subscribe(onNext: { status in
            switch status {
            case .endHeaderRefresh:
                collectView.header?.stopRefreshing()
            case .endFooterRefresh:
                collectView.footer?.stopRefreshing()
            default:
                break
            }
        }
        ).disposed(by: viewModel.disposeBag)
        
        viewModel.models.asDriver().drive(collectView.rx.items(dataSource: dataSource)).disposed(by: viewModel.disposeBag)
        
        
        collectView.rx.itemSelected.subscribe { index in
            let model = self.viewModel.models.value.first?.items[index.element!.row]
            let vc = JSGoodsDetailViewController()
            vc.goodsId = model!.id
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            
            
        }.disposed(by: viewModel.disposeBag)
       
        
        
        
        
        
    }
}

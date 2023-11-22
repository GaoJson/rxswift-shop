//
//  JSHomeTopView.swift
//  shop
//
//  Created by zyjz on 2023/11/2.
//

import UIKit
import FSPagerView
import Kingfisher
import RxSwift
import RxDataSources
import RxCocoa

class JSHomeTopView: UIView {
        
    init(frame: CGRect,viewModel:JSHomeViewModel) {
        super.init(frame: frame)
        setUI(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var bannerList:Array<BannerModel> = []
    
    var dataModel:JSHomeViewModel?
    
    lazy var pageControl:FSPageControl={
        let pageControl = FSPageControl(frame: CGRect.zero)
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    func setUI(viewModel:JSHomeViewModel) {
        dataModel = viewModel
        let pageView = FSPagerView(frame:CGRect(x: 0, y: 0, width: ScreenTool.SCREEN_WIDTH, height: 200))
        pageView.delegate = self
        pageView.dataSource = self
        pageView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        pageView.automaticSlidingInterval = 4
        pageView.isInfinite = true
        self.addSubview(pageView)
        
        pageView.addSubview(self.pageControl)
        pageView.bringSubviewToFront(self.pageControl)
        pageControl.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(pageView)
            make.height.equalTo(40)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: ScreenTool.SCREEN_WIDTH/5, height: 75)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectView = UICollectionView(frame:CGRect(x: 0, y: 200, width: ScreenTool.SCREEN_WIDTH, height: 150) , collectionViewLayout: layout)
        collectView.register(CategoryCell.self,
                                             forCellWithReuseIdentifier: "Cell")
        self.addSubview(collectView)
        
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String,CategoryModel>> { (ds, cv, indexPath, element) in
            let cell:CategoryCell = cv.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCell
            cell.titleLabel?.text = element.cname
            cell.img?.kf.setImage(with: URL(string: element.imgUrl))
            return cell
        }
        
        let models = BehaviorRelay<[SectionModel<String,CategoryModel>]>(value: [])
        models.asDriver().drive(
            collectView.rx.items(dataSource: dataSource)
        ).disposed(by: viewModel.disposeBag)
        
        viewModel.topModel.asDriver().drive {[weak self] model in
            self?.pageControl.numberOfPages = self?.dataModel?.topModel.value.topBannerVos.count ?? 0
            var sectionsData = [SectionModel<String,CategoryModel>]()
            sectionsData.append(SectionModel(model: "", items: viewModel.topModel.value.tgoodsCategoryVos))
            models.accept(sectionsData)
            self?.bannerList = model.topBannerVos
            pageView.reloadData()
        }.disposed(by: viewModel.disposeBag)
    }
}

extension JSHomeTopView:FSPagerViewDataSource,FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.bannerList.count
    }
    
    func pagerView(_ pagerView:FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell:FSPagerViewCell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSPagerViewCell", at: index)
        cell.isHighlighted = false
        let model = self.bannerList[index]
        cell.imageView?.kf.setImage(with: URL(string:model.coverImg))
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int) {
        self.pageControl.currentPage = index
    }
}

class CategoryCell:UICollectionViewCell {
    var titleLabel:UILabel?
    var img:UIImageView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imgV = UIImageView()
        self.addSubview(imgV)
        imgV.snp.makeConstraints({ make in
            make.centerX.equalTo(self)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.top.equalTo(15)
        })
        img = imgV
        
        
        
    
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(label)
        label.text = "12312"
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(imgV.snp_bottomMargin).offset(10)
        }
        
        
        self.titleLabel = label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

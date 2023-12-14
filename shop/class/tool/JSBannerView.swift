//
//  JSBannerView.swift
//  shop
//
//  Created by zyjz on 2023/12/8.
//

import UIKit
import FSPagerView

class JSBannerView: UIView {

    var bannerList:Array<String> = []
    
    func reloadData(list:Array<String>){
        bannerList = list
        self.pageControl.numberOfPages = list.count
        pageView.reloadData()
    }
    
    lazy var pageView:FSPagerView={
        let pageView = FSPagerView(frame:self.bounds)
        pageView.delegate = self
        pageView.dataSource = self
        pageView.register(JSBannerCell.self, forCellWithReuseIdentifier: "JSBannerCell")
        pageView.automaticSlidingInterval = 4
        pageView.isInfinite = true
        return pageView
    }()
    
    lazy var pageControl:FSPageControl={
        let pageControl = FSPageControl(frame: CGRect.zero)
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.addSubview(self.pageView)
        pageView.addSubview(self.pageControl)
        pageView.bringSubviewToFront(self.pageControl)
        pageControl.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(pageView)
            make.height.equalTo(40)
        }
    }
    
}

extension JSBannerView:FSPagerViewDataSource,FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.bannerList.count
    }
    
    func pagerView(_ pagerView:FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell:JSBannerCell = pagerView.dequeueReusableCell(withReuseIdentifier: "JSBannerCell", at: index) as! JSBannerCell
          
        cell.images?.kf.setImage(with: URL(string:self.bannerList[index]))
    
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int) {
        self.pageControl.currentPage = index
    }
}

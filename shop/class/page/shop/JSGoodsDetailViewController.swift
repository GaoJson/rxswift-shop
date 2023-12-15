//
//  JSGoodsDetailViewController.swift
//  shop
//
//  Created by zyjz on 2023/12/8.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit

class JSGoodsDetailViewController: JSBaseViewController {
    
    var goodsId = 0
    let goodsModel = PublishSubject<GoodsModel>()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商品详情"
        self.view.backgroundColor = .white
        loadData()
        setUI()
    }
    
    func loadData() {
        HttpTool.getRequest(url: JSApi.goodsDetail+"\(goodsId)") { res in
            self.goodsModel.onNext(GoodsModel.deserialize(from: res as? Dictionary<String, Any>) ?? GoodsModel())
        } fail: { _ in
            
        }
    }
    
    func setUI() {
        let contentView = UIScrollView()
        self.view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
           
        }
        contentView.contentSize = CGSizeMake(UIDevice.SCREEN_WIDTH,UIDevice.SCREEN_HEIGHT)
        
        let bannerView = JSBannerView(frame: CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: 300))
        contentView.addSubview(bannerView)
        
        let priceLb = UILabel()
        priceLb.textColor = .red
        priceLb.font = .systemFont(ofSize: 20)
        contentView.addSubview(priceLb)
        priceLb.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(320)
        }
        
        let oriPriceLb = UILabel()
        oriPriceLb.textColor = .black99
        oriPriceLb.font = .systemFont(ofSize: 15)
        contentView.addSubview(oriPriceLb)
        oriPriceLb.snp.makeConstraints { make in
            make.left.equalTo(priceLb.snp.right).offset(10)
            make.bottom.equalTo(priceLb)
        }
        let oriLine = UIView()
        oriLine.backgroundColor = .black99
        oriPriceLb.addSubview(oriLine)
        oriLine.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
            make.left.right.equalTo(0)
        }
   
        let nameLb = UILabel()
        nameLb.textColor = .black
        nameLb.font = .systemFont(ofSize: 16)
        nameLb.numberOfLines = 0
        contentView.addSubview(nameLb)
        nameLb.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.width.equalTo(UIDevice.SCREEN_WIDTH-20)
            make.top.equalTo(priceLb.snp.bottom).offset(10)
        }
        
        let bckLine = UIView()
        bckLine.backgroundColor = .bckColor
        contentView.addSubview(bckLine)
        bckLine.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.width.equalTo(UIDevice.SCREEN_WIDTH)
            make.top.equalTo(nameLb.snp.bottom).offset(8)
            make.height.equalTo(6)
        }
        
        let remoteLb = UILabel()
        remoteLb.text = "该商品不发货偏远地区"
        remoteLb.textColor = .black99
        remoteLb.font = .systemFont(ofSize: 14)
        remoteLb.numberOfLines = 0
        contentView.addSubview(remoteLb)
        remoteLb.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.height.equalTo(40)
            make.top.equalTo(bckLine.snp.bottom).offset(0)
        }
        
        let bckLine1 = UIView()
        bckLine1.backgroundColor = .bckColor
        contentView.addSubview(bckLine1)
        bckLine1.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.width.equalTo(UIDevice.SCREEN_WIDTH)
            make.top.equalTo(remoteLb.snp.bottom).offset(0)
            make.height.equalTo(6)
        }
        
        let detailLb = UILabel()
        detailLb.text = "商品详情"
        detailLb.textColor = .black99
        detailLb.font = .systemFont(ofSize: 14)
        detailLb.numberOfLines = 0
        contentView.addSubview(detailLb)
        detailLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(bckLine1.snp.bottom).offset(0)
        }
        
        let webView = WKWebView()
        webView.sizeToFit()
        contentView.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.width.equalTo(UIDevice.SCREEN_WIDTH)
            make.top.equalTo(detailLb.snp.bottom).offset(0)
            make.height.equalTo(800)
        }
        webView.rx.didFinishLoad.subscribe { _ in
            webView.evaluateJavaScript("document.body.offsetHeight") { res, _ in
                let height = Double("\(res!)")
                webView.snp.updateConstraints { make in
                    make.height.equalTo(height!)
                }
                contentView.snp.remakeConstraints{ make in
                    make.left.right.equalTo(0)
                    make.top.equalTo(0)
                    make.bottom.equalTo(webView.snp.bottom).offset(50+UIDevice.BOTTOM_HEIGHT)
                }
               
            }
        }.disposed(by: disposeBag)
        
        
        
        let bottomView = UIView()
        self.view.addSubview(bottomView)
        bottomView.backgroundColor = .white
        bottomView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.height.equalTo(50+UIDevice.BOTTOM_HEIGHT)
            make.bottom.equalTo(0)
        }
        
        let buyBtn = UIButton()
        bottomView.addSubview(buyBtn)
        buyBtn.titleLabel?.font = .systemFont(ofSize: 14)
        buyBtn.layer.cornerRadius = 20
        buyBtn.backgroundColor = .red
        buyBtn.setTitle("立即购买", for: .normal)
        buyBtn.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.height.equalTo(40)
            make.top.equalTo(8)
            make.width.equalTo(200.w)
        }
        buyBtn.rx.tap.subscribe { _ in
            debugPrint(contentView)
            debugPrint(webView)
        }.disposed(by: disposeBag)
        
        let carBtn = UIButton()
        bottomView.addSubview(carBtn)
        carBtn.titleLabel?.font = .systemFont(ofSize: 14)
        carBtn.layer.cornerRadius = 20
        carBtn.backgroundColor = .hexColor(rgbValue: 0xFBB62B)
        carBtn.setTitle("加入购物车", for: .normal)
        carBtn.snp.makeConstraints { make in
            make.right.equalTo(buyBtn.snp.left).offset(-5)
            make.height.equalTo(40)
            make.top.equalTo(8)
            make.width.equalTo(200.w)
        }
        
        
        goodsModel.subscribe { model in
           let bannerList = model.element!.goodsBanner.components(separatedBy: ",")
            bannerView.reloadData(list: bannerList)
            
            nameLb.text = model.element?.goodsName
            priceLb.text = "¥\(Double(model.element?.goodsPrice ?? "0") ?? 0)"
            
            oriPriceLb.text = "¥\(Double(model.element?.originalPrice ?? "0") ?? 0)"
            
            
            let head = "<head>" + "<meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=no'>" +
                                    "<style>*{margin:0;padding:0;}img{max-width: 100%; width:auto; height:auto;}</style>" +
                                    "</head>";
            let content = "<html>\(head)"+"<body>\(model.element!.goodsContent) </body></html>"
            debugPrint(content)
            
            webView.loadHTMLString(content, baseURL: nil)
            
            
        }.disposed(by: disposeBag)
        
        
        
        
        
    }
    
    
    
    
}

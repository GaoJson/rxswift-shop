//
//  HomeModel.swift
//  shop
//
//  Created by zyjz on 2023/11/1.
//

import Foundation
import HandyJSON

struct HomeModel:HandyJSON {
    var hotGoodsVo:Array<GoodsModel> = []
    var topBannerVos:Array<BannerModel> = []
    var tgoodsCategoryVos:Array<CategoryModel> = []
}

struct GoodsModel:HandyJSON {
    var id:Int = 0
    var goodsImg:String = ""
    var goodsBanner:String = ""
    var goodsName:String = ""
    var spec:String = ""
    var goodsPrice:String = ""
    var originalPrice:String = ""
}

struct BannerModel:HandyJSON {
    var id:Int = 0
    var jumpType:Int = 0
    var sort:Int = 0
    var type:Int = 0
    var coverImg:String = ""
    var name:String = ""
}

struct CategoryModel:HandyJSON {
    var id:Int = 0
    var sort:Int = 0
    var imgUrl:String = ""
    var cname:String = ""
}

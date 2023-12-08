//
//  SelectAddressModel.swift
//  shop
//
//  Created by zyjz on 2023/12/6.
//

import Foundation
import HandyJSON

struct SelectAddressModel:HandyJSON {
    
    var list:Array<AddressProvinceModel> = []
}

struct AddressProvinceModel:HandyJSON {
    var cityList:Array<AddressCityModel> = []
    var provinceName:String = ""
    var provinceId:Int = 0
}

struct AddressCityModel:HandyJSON {
    var areaList:Array<AddressAreaModel> = []
    var cityName:String = ""
    var cityId:Int = 0
}
struct AddressAreaModel:HandyJSON {
    var townList:Array<AddressTownModel> = []
    var areaName:String = ""
    var areaId:Int = 0
}
struct AddressTownModel:HandyJSON {
    var townName:String = ""
    var townId:Int = 0
    var index:Int = 0
}

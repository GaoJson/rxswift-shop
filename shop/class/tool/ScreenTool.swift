//
//  ScreenTool.swift
//  shop
//
//  Created by zyjz on 2023/11/2.
//

import Foundation
import UIKit


extension UIDevice {
    static let SCREEN_WIDTH = UIScreen.main.bounds.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    static let STATUS_HEIGHT = ScreenTool.singleton.getStatusHeight()
    static let BOTTOM_HEIGHT = ScreenTool.singleton.getBottomHeight()
    
    static let NAV_HEIGHT = 44.0
    static let TABBAR_HEIGHT = 49.0
    
}


class ScreenTool:NSObject {

    static let SCREEN_WIDTH = UIScreen.main.bounds.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    static let NAV_HEIGHT = 44.0
    static let TABBAR_HEIGHT = 49.0

    static let singleton = ScreenTool()
    private override init() {
        super.init()
    }
    
    var designWidth = 750
    var designHeight = 1334
        
    var statusHeight:CGFloat = 0.0
    func getStatusHeight()->CGFloat {
        if(statusHeight > 0) {
            return statusHeight
        }
        if #available(iOS 13.0, *) {
            let set:NSSet = UIApplication.shared.connectedScenes as NSSet
            let scene:UIWindowScene = set.anyObject() as! UIWindowScene
            let window = scene.windows.first
            statusHeight = window?.safeAreaInsets.top ?? 20
        } else {
            statusHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        }
        
        return statusHeight
    }
    
    var bottomHeight:CGFloat = 0.0
    func getBottomHeight() ->CGFloat {
        if(bottomHeight > 0) {
            return bottomHeight
        }
        if #available(iOS 13.0, *) {
            let set:NSSet = UIApplication.shared.connectedScenes as NSSet
            let scene:UIWindowScene = set.anyObject() as! UIWindowScene
            let window = scene.windows.first
            bottomHeight = window?.safeAreaInsets.bottom ?? 0
        } else {
            bottomHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        }
        
        return bottomHeight
    }
}



extension Int {
     var w: Double {
            get {
                let data = (Double(ScreenTool.singleton.designWidth)/Double(UIScreen.main.bounds.width)) * Double(self)
                return Double(round(10 * data) / 10)
            }
        }
}



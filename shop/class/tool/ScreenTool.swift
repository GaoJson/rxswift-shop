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
    
    
    
    
    
    
}



class ScreenTool:NSObject {
    
    static let SCREEN_WIDTH = UIScreen.main.bounds.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    
    static let NAV_HEIGHT = 44.0
    static let TABBAR_HEIGHT = 49.0
    
    static let STATUS_HEIGHT = ScreenTool.singleton.getStatusHeight()
    static let BOTTOM_HEIGHT = ScreenTool.singleton.getBottomHeight()
    
    
    
    static let singleton = ScreenTool()
    private override init() {
        super.init()
    }
    
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

extension UIColor {
    class var randomColor: UIColor {
            get {
                let red = CGFloat(arc4random()%256)/255.0
                let green = CGFloat(arc4random()%256)/255.0
                let blue = CGFloat(arc4random()%256)/255.0
                return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            }
        }
    class var bckColor: UIColor {
            get {
                let red = CGFloat(236)/255.0
                let green = CGFloat(236)/255.0
                let blue = CGFloat(236)/255.0
                return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            }
        }
    
}

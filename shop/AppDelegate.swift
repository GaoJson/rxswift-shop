//
//  AppDelegate.swift
//  shop
//
//  Created by zyjz on 2023/10/31.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

   
    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .default
        IQKeyboardManager.shared.enable = true
        debugPrint(ScreenTool.SCREEN_WIDTH)
        debugPrint(10.w)
        
        UserInfo.share.getUser()
        setNavbar()
        WCDBUtil.share.connectDatabase()
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.rootViewController = JSTabbarViewController()
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

 
    func setNavbar(){
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor.white; //背景色
            appearance.shadowColor = UIColor.black; //阴影
            
        } else {
            // Fallback on earlier versions
        };
               
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            let backImage = R.image.icon_arrow_right_gray()
            UINavigationBar.appearance().backIndicatorImage = backImage
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
            
            let tabbar = UITabBarAppearance()
            tabbar.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = tabbar
            UITabBar.appearance().scrollEdgeAppearance = tabbar
        }
        
        
    }


}


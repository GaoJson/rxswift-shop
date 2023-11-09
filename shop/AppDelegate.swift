//
//  AppDelegate.swift
//  shop
//
//  Created by zyjz on 2023/10/31.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

   
    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
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
            
            let tabbar = UITabBarAppearance()
            tabbar.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = tabbar
            UITabBar.appearance().scrollEdgeAppearance = tabbar
        }
        
        
    }


}


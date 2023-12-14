//
//  colorTool.swift
//  shop
//
//  Created by zyjz on 2023/11/10.
//

import Foundation
import UIKit

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
    class func hexColor(rgbValue: UInt)-> UIColor {
            return  UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
    
    class var black33: UIColor {
            get {
                return  hexColor(rgbValue: 0x333333)
            }
        }
    class var black66: UIColor {
            get {
                return  hexColor(rgbValue: 0x666666)
            }
        }
    class var black99: UIColor {
            get {
                return  hexColor(rgbValue: 0x999999)
            }
        }
    
}

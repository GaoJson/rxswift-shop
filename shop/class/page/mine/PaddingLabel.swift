//
//  PaddingLabel.swift
//  shop
//
//  Created by zyjz on 2023/11/18.
//

import UIKit

class PaddingLabel: UILabel {

    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

       override func drawText(in rect: CGRect) {
           super.drawText(in: rect.inset(by: padding))
       }

       override var intrinsicContentSize: CGSize {
           get {
               var contentSize = super.intrinsicContentSize
               contentSize.width += padding.left + padding.right
               contentSize.height += padding.top + padding.bottom
               return contentSize
           }
       }


}

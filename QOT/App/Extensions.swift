//
//  Extensions.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIFont

extension UIFont {
    
    class func simpleFont(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: FontName.simple.rawValue, size: ofSize)
    }
    
    class func bentonBookFont(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: FontName.bentonBook.rawValue, size: ofSize)
    }
    
    class func bentonRegularFont(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: FontName.bentonBook.rawValue, size: ofSize)
    }
    
    class var sidebarSmall: UIFont? {
        return UIFont.bentonBookFont(ofSize: 16)
    }
    
    class var sidebar: UIFont? {
        return UIFont.bentonBookFont(ofSize: 32)
    }
}

// MARK: - UIColor

extension UIColor {
    
    class var qotWhite: UIColor {
        return UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    class var qotWhiteLight: UIColor {
        return UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.1)
    }
    
    class var qotWhiteMedium: UIColor {
        return UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.4)
    }
    
    class var qotNavy: UIColor {
        return UIColor.init(red: 0, green: 45/255, blue: 78/255, alpha: 1)
    }
}

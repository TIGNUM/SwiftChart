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
    
    // MARK: - Private
    
    private class func simpleFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.simple.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
    
    private class func bentonBookFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.bentonBook.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
    
    private class func bentonRegularFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.bentonBook.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
    
    // MARK: - Public
    
    class var sidebarSmall: UIFont {
        return UIFont.simpleFont(ofSize: 16)
    }
    
    class var sidebar: UIFont {
        return UIFont.simpleFont(ofSize: 32)
    }
    
    class var bubbleTitle: UIFont {
        return UIFont.bentonBookFont(ofSize: 16)
    }
    class var bubbleSubTitle: UIFont {
        return UIFont.simpleFont(ofSize: 10)
    }
    
}

// MARK: - UIColor

extension UIColor {
    
    class var qotWhite: UIColor {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    class var qotWhiteLight: UIColor {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
    }
    
    class var qotWhiteMedium: UIColor {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
    }
    
    class var qotNavy: UIColor {
        return UIColor(red: 0, green: 45/255, blue: 78/255, alpha: 1)
    }
}

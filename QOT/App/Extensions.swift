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
    
    class var sidebarSmall: UIFont? {
        return UIFont.simpleFont(ofSize: 16)
    }
    
    class var sidebar: UIFont? {
        return UIFont.simpleFont(ofSize: 24)
    }
}

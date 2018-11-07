//
//  UIDevice+Convenience.swift
//  QOT
//
//  Created by karmic on 12.09.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

extension UIDevice {

    static var isPad: Bool {
        return UIDevice.current.model.contains("iPad")
    }
    
    static var isVersion10: Bool {
        if #available(iOS 11.0, *) {
            return false
        } else {
            return true
        }
    }
}

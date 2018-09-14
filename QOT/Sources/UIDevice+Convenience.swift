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
}

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

    static var isSmallScreenDevice: Bool {
        let isFourSeries = UIDevice.current.deviceName.lowercased().range(of: "iphone 4") != nil
        let isFiveSeries = UIDevice.current.deviceName.lowercased().range(of: "iphone 5") != nil
        let isSEiPhone = UIDevice.current.deviceName.lowercased().range(of: "iphone SE") != nil
        let isiPod = UIDevice.current.deviceName.lowercased().range(of: "ipod") != nil

        return isFourSeries || isFiveSeries || isiPod || isSEiPhone
    }

    static var isVersion10: Bool {
        if #available(iOS 11.0, *) {
            return false
        } else {
            return true
        }
    }
}

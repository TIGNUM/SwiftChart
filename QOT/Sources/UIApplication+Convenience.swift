//
//  UIApplication+Convenience.swift
//  QOT
//
//  Created by karmic on 10.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

public protocol ApplicationStatusBarStyle {
    func setStatusBarStyle(_ statusBarStyle: UIStatusBarStyle)
}

extension UIApplication: ApplicationStatusBarStyle {
    public func setStatusBarStyle(_ statusBarStyle: UIStatusBarStyle) {
        setStatusBarStyle(Date().isNight ? .lightContent : .default, animated: true)
    }
}

extension UIApplication {

    class func openAppSettings() {
        guard let url = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

//
//  UIViewAnimationOptions+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 07/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

extension UIViewAnimationOptions {
    init(curve: UIViewAnimationCurve) {
        switch curve {
        case .easeIn:
            self = .curveEaseIn
        case .easeOut:
            self = .curveEaseOut
        case .easeInOut:
            self = .curveEaseInOut
        case .linear:
            self = .curveLinear
        default:
            self = .curveLinear
        }
    }
}

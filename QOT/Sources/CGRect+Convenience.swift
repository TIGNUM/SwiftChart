//
//  CGRect+Convenience.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 16/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

extension CGRect {

    var center: CGPoint {
        get {
            return CGPoint(x: origin.x + width / 2, y: origin.y + height / 2)
        }
        set {
            origin = CGPoint(x: newValue.x - width / 2, y: newValue.y - height / 2)
        }
    }

    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
        self.init(origin: origin, size: size)
    }
}

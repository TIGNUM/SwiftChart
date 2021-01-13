//
//  NSLayoutConstraint+Extension.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 13.01.2021.
//  Copyright © 2021 Tignum. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    static func getConstantConstraint(item: Any,
                                    constant: CGFloat,
                                    attribute attr1: NSLayoutConstraint.Attribute) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item,
                                            attribute: attr1,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: 40)
        constraint.priority = UILayoutPriority(rawValue: 999)
        return constraint
    }
}

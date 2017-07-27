//
//  PassthroughView.swift
//  QOT
//
//  Created by Lee Arromba on 26/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

// @see https://stackoverflow.com/questions/3834301/ios-forward-all-touches-through-a-view
class PassthroughView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for view in subviews {
            if !view.isHidden && view.point(inside: self.convert(point, to: view), with: event) {
                return true
            }
        }
        return false
    }
}

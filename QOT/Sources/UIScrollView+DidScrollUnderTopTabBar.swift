//
//  UIScrollView+DidScrollUnderTopTabBar.swift
//  QOT
//
//  Created by karmic on 24.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

protocol TopTabBarScrollViewDelegate: class {
    func didScrollUnderTopTabBar(alpha: CGFloat)
}

extension UIScrollView {

    func didScrollUnderTopTabBar(delegate: TopTabBarScrollViewDelegate?) {
        if contentOffset.y > 0 {
            let alpha = abs(contentOffset.y) / 64
            delegate?.didScrollUnderTopTabBar(alpha: alpha)
        }
    }
}

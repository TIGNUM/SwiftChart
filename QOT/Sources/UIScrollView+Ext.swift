//
//  UIScrollView+Ext.swift
//  QOT
//
//  Created by karmic on 30.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToBottom(_ animated: Bool = true) {
        let point = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(point, animated: animated)
    }

    func scrollToTop(_ animated: Bool = true) {
        setContentOffset(.zero, animated: animated)
    }
}

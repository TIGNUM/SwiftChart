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
        let rect = CGRect(x: 0,
                          y: contentSize.height - bounds.size.height,
                          width: bounds.size.width,
                          height: bounds.size.height)
        scrollRectToVisible(rect, animated: animated)
    }
}

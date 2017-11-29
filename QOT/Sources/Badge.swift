//
//  Badge.swift
//  QOT
//
//  Created by Lee Arromba on 08/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class Badge: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.width == bounds.height else {
            assertionFailure("badge width must equal height - w:\(bounds.width), h:\(bounds.height)")
            return
        }
        layer.cornerRadius = bounds.height / 2
    }
}

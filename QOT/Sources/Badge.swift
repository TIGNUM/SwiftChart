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
        layer.cornerRadius = bounds.height / 2
    }
}

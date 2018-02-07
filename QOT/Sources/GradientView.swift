//
//  FadeView.swift
//  QOT
//
//  Created by Sam Wyndham on 07/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class GradientView: UIView {

    init(colors: [UIColor], locations: [Double]) {
        super.init(frame: CGRect.zero)

        if let layer = layer as? CAGradientLayer {
            layer.colors = colors.map { $0.cgColor }
            layer.locations = locations.map { NSNumber(value: $0) }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

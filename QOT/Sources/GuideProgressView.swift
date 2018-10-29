//
//  GuideProgressView.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 24.10.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

enum ProgressType {
    case load
    case recovery
}

final class GuideProgressView: UIProgressView {

    // MARK: - Properties

    var type: ProgressType?

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        dropShadow(color: .white, opacity: 0.2, offSet: .zero, radius: 6, scale: true)
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: 4.0)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
    }

    // MARK: - Actions

    func startNullStateAnimation() {
        UIView.animate(withDuration: Animation.duration_1, animations: {
            self.setProgress(self.type == .load ? 0.3 : 0.8, animated: true)
        })
    }
}

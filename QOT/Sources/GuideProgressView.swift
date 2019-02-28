//
//  GuideProgressView.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 24.10.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class GuideProgressView: UIProgressView {

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: 4.0)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
    }

    // MARK: - Actions

    func setGradient(with colors: [UIColor], progressColor: UIColor = .guideProgressTintColor) {
        let gradientView = UIView(frame: bounds)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint =  CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        let gradientImage = UIImage(view: gradientView)?.withHorizontallyFlippedOrientation()
        trackImage = gradientImage
        transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        progressTintColor = progressColor
    }
}

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
        dropShadow(color: .white, opacity: 0.2, offSet: .zero, radius: 6, scale: true)
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: 4.0)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
    }

    // MARK: - Actions

    func startNullStateAnimation() {
        UIView.animate(withDuration: 7, delay: 0, options: [.repeat], animations: {
            UIView.animate(withDuration: 2, animations: {
                self.setProgress(0.3, animated: true)
            }, completion: { _ in
                UIView.animate(withDuration: 2, animations: {
                    self.setProgress(0.6, animated: true)
                }, completion: { _ in
                    UIView.animate(withDuration: 2, animations: {
                        self.setProgress(1.0, animated: true)
                    })
                })
            })
        }, completion: { _ in
            self.setProgress(0, animated: false)
        })
    }
}

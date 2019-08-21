//
//  LoadingDotsView.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 23.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class DotsLoadingView: UIView {

    // MARK: - Properties

    private var dotsColor: UIColor? = .carbonDark
    private var size: CGSize? = nil

    // MARK: - Configuration
    func configure(dotsColor: UIColor?, size: CGSize? = nil) {
        self.dotsColor = dotsColor
        if let size = size {
            self.size = size
        }
    }

    // MARK: - Actions
    func startAnimation() {
        if self.superview == nil {
            return
        }
        if alpha == 0 {
            alpha = 1
        }
        setupAnimation(size: size ?? frame.size, color: dotsColor)
    }

    func startAnimation(withDuration duration: TimeInterval) {
        startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.stopAnimation()
        }
    }

    func stopAnimation() {
        if alpha > 0 {
            UIView.animate(withDuration: Animation.duration_03) {
                self.alpha = 0
            }
        }
    }
}

// MARK: - Animation
private extension DotsLoadingView {
    func setupAnimation(size: CGSize, color: UIColor?) {
        let dotSpacing: CGFloat = 2
        let dotSize: CGFloat = (size.width - 2 * dotSpacing) / 3
        let x: CGFloat = (layer.bounds.size.width - size.width) / 2
        let y: CGFloat = (layer.bounds.size.height - dotSize) / 2
        let duration: CFTimeInterval = 0.75
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.12, 0.24, 0.36]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.keyTimes = [0, 0.3, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.3, 1]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        for index in 0 ..< 3 {
            let circle = dotLayer(size: CGSize(width: dotSize, height: dotSize), color: color)
            let x = x + dotSize * CGFloat(index) + dotSpacing * CGFloat(index)
            let frame = CGRect(x: x, y: y, width: dotSize, height: dotSize)
            animation.beginTime = beginTime + beginTimes[index]
            circle.frame = frame
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
    }
}

// MARK: - Layer
private extension DotsLoadingView {
    func dotLayer(size: CGSize, color: UIColor?) -> CAShapeLayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                                              radius: size.width / 2,
                                              startAngle: 0,
                                              endAngle: CGFloat(2 * Double.pi),
                                              clockwise: false)
        layer.path = path.cgPath
        layer.backgroundColor = nil
        layer.fillColor = color?.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return layer
    }
}

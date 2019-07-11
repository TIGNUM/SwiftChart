//
//  GradientArcView.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

/// This draws an arc, of length `maxAngle`, ending at `endAngle. This is `@IBDesignable`, so if you
/// put this in a separate framework target, you can use this class in Interface Builder. The only
/// property that is not `@IBInspectable` is the `lineCapStyle` (as IB doesn't know how to show that).
///
/// If you want to make this animated, just use a `CADisplayLink` update the `endAngle` property (and
/// this will automatically re-render itself whenever you change that property).

@IBDesignable
class GradientArcView: UIView {

    /// Width of the stroke.
    @IBInspectable var lineWidth: CGFloat = 3 {
        didSet {
            setNeedsDisplay(self.bounds)
        }
    }

    /// Color of the stroke (at full alpha, at the end).
    @IBInspectable var strokeColor: UIColor = .accent75 {
        didSet {
            setNeedsDisplay(self.bounds)
        }
    }

    /// Where the arc should end, measured in degrees, where 0 = "3 o'clock".
    @IBInspectable var endAngle: CGFloat = 0 {
        didSet {
            setNeedsDisplay(self.bounds)
        }
    }
    /// What is the full angle of the arc, measured in degrees, e.g. 180 = half way around, 360 = all the way around, etc.
    @IBInspectable var maxAngle: CGFloat = 2.0*CGFloat.pi {
        didSet {
            setNeedsDisplay(self.bounds)
        }
    }
    /// What is the shape at the end of the arc.
    var lineCapStyle: CGLineCap = .square {
        didSet {
            setNeedsDisplay(self.bounds)
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let gradations = 255

        let startAngle = -endAngle + maxAngle
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        var angle = startAngle

        for i in 1 ... gradations {
            let percent = CGFloat(i) / CGFloat(gradations)
            let endAngle = startAngle - percent * maxAngle

            let context = UIGraphicsGetCurrentContext()!
            context.setLineWidth(lineWidth)
            context.setStrokeColor(strokeColor.withAlphaComponent(percent).cgColor)
            context.addArc(center: center, radius: radius, startAngle: angle, endAngle: endAngle, clockwise: true)
            context.setLineCap(lineCapStyle)
            context.strokePath()
            angle = endAngle
        }
    }
}

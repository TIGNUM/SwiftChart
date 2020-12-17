//
//  FullScreenBackgroundCircleView.swift
//  QOT
//
//  Created by Sanggeon Park on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

struct CircleInfo {
    let color: UIColor
    let radiusRate: CGFloat
}

class FullScreenBackgroundCircleView: UIView {
    var circles: [CircleInfo] = [
        CircleInfo(color: .white30, radiusRate: 0.2),
        CircleInfo(color: .white20, radiusRate: 0.4),
        CircleInfo(color: .white10, radiusRate: 0.7),
        CircleInfo(color: .white10, radiusRate: 0.99)
        ] {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        // Drawing code
        let width = rect.size.width
        let center = rect.center
        for circleInfo in circles {
            let diameter = width * circleInfo.radiusRate
            let rect = CGRect(center: center, size: CGSize(width: diameter, height: diameter))
            var path = UIBezierPath()
            path = UIBezierPath(ovalIn: rect)
            circleInfo.color.setStroke()
            UIColor.clear.setFill()
            path.lineWidth = 1
            path.stroke()
            path.fill()
        }
    }
}

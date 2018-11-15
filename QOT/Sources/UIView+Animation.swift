//
//  UIView+Animation.swift
//  QOT
//
//  Created by Sanggeon Park on 19.09.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

extension UIView {
    func pulsate(_ times: Float = 1,
                 duration: TimeInterval = Animation.duration,
                 autoreverse: Bool = false) {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = duration
        pulse.fromValue = 1.1
        pulse.toValue = 1.0
        pulse.repeatCount = times
        pulse.autoreverses = autoreverse
        layer.add(pulse, forKey: "pulse")
    }

    func verticalBounce(_ times: Float = 1,
                        offset: CGFloat = 0,
                        duration: TimeInterval = Animation.duration,
                        autoreverse: Bool = true) {
        let bounce = CABasicAnimation(keyPath: "position.y")
        let center  = frame.midY
        bounce.duration = duration
        bounce.fromValue = center
        bounce.toValue = center + offset
        bounce.repeatCount = times
        bounce.autoreverses = autoreverse
        layer.add(bounce, forKey: "verticalPosition")
    }
}

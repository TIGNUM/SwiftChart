//
//  UIView+Animation.swift
//  QOT
//
//  Created by Sanggeon Park on 19.09.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

extension UIView {
    private struct AnimationKey {
        static let pulse = "pulse"
        static let verticalBounce = "verticalBounce"
        static let rotation = "rotation"
    }

    func pulsate(_ times: Float = 1,
                 duration: TimeInterval = Animation.duration_03,
                 autoreverse: Bool = false) {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = duration
        pulse.fromValue = 1.1
        pulse.toValue = 1.0
        pulse.repeatCount = times
        pulse.autoreverses = autoreverse
        layer.add(pulse, forKey: AnimationKey.pulse)
    }

    func verticalBounce(_ times: Float = 1,
                        offset: CGFloat = 0,
                        duration: TimeInterval = Animation.duration_03,
                        autoreverse: Bool = true) {
        let bounce = CABasicAnimation(keyPath: "position.y")
        let center  = frame.midY
        bounce.duration = duration
        bounce.fromValue = center
        bounce.toValue = center + offset
        bounce.repeatCount = times
        bounce.autoreverses = autoreverse
        layer.add(bounce, forKey: AnimationKey.verticalBounce)
    }

    func startRotating(duration: Double = Animation.duration_1_5) {
        let kAnimationKey = AnimationKey.rotation

        guard self.layer.animation(forKey: kAnimationKey) == nil else {
            return
        }
        let animate = CABasicAnimation(keyPath: "transform.rotation")
        animate.duration = duration
        animate.repeatCount = Float.infinity
        animate.fromValue = 2.0*Double.pi
        animate.toValue = 0
        self.layer.add(animate, forKey: kAnimationKey)
    }

    func stopRotating() {
        let kAnimationKey = AnimationKey.rotation

        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }

    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransition)
    }
}

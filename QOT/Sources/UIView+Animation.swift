//
//  UIView+Animation.swift
//  QOT
//
//  Created by Sanggeon Park on 19.09.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

extension UIView {
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = Animation.duration
        pulse.fromValue = 1.1
        pulse.toValue = 1.0
        layer.add(pulse, forKey: "pulse")
    }
}

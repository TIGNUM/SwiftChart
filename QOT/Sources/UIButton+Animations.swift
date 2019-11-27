//
//  UIButton+Animations.swift
//  QOT
//
//  Created by Srikanth Roopa on 12.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

extension UIButton {
    func flipImage(_ state: Bool, _ completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.75,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
                        self.imageView?.transform = CGAffineTransform(scaleX: 1.0, y: state ? 1.0 : -1.0)
        }, completion: completion)
    }
}

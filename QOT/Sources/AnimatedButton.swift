//
//  AnimatedButton.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 11/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol AnimatedButtonDelegate: class {
    func willShowPressed()
    func willShowUnpressed()
}

class AnimatedButton: UIButton {
    weak var delegate: AnimatedButtonDelegate?
    var shouldAnimate = true

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        willShowPressed()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        willShowUnpressed()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        willShowUnpressed()
    }

    func willShowPressed() {
        if !shouldAnimate { return }
        if let delegate = delegate {
            delegate.willShowPressed()
        } else {
            UIView.animate(withDuration: 0.25) {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        }
    }

    func willShowUnpressed() {
        isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isUserInteractionEnabled = true
        }

        if !shouldAnimate { return }
        if let delegate = delegate {
            delegate.willShowUnpressed()
        } else {
            UIView.animate(withDuration: 0.25) {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
    }
}

//
//  FadeAnimator.swift
//  QOT
//
//  Created by Moucheg Mouradian on 11/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    fileprivate let duration = 1.0
    var presenting = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let animatedView = presenting ? toView : transitionContext.view(forKey: .from)!

        containerView.addSubview(toView)
        containerView.bringSubview(toFront: animatedView)

        toView.alpha = 1
        animatedView.alpha = presenting ? 0 : 1
        UIView.animate(withDuration: duration, animations: {
            animatedView.alpha = self.presenting ? 1 : 0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}

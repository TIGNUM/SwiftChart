//
//  FadeAnimator.swift
//  QOT
//
//  Created by Moucheg Mouradian on 11/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate(set) var fromViewController: UIViewController?
    fileprivate(set) var toViewController: UIViewController?
    fileprivate let duration = 1.0
    var presenting = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }
        self.fromViewController = fromViewController
        self.toViewController = toViewController

        fromViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let animatedView = presenting ? toView : transitionContext.view(forKey: .from)!
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: animatedView)

        toView.alpha = 1
        animatedView.alpha = presenting ? 0 : 1
        UIView.animate(withDuration: duration, animations: {
            animatedView.alpha = self.presenting ? 1 : 0
        }, completion: { finished in
            if finished {
                fromViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
            }
            transitionContext.completeTransition(finished)
        })
    }
}

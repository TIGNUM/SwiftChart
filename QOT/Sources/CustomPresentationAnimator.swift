//
//  CustomPresentationAnimator.swift
//  QOT
//
//  Created by Lee Arromba on 25/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol CustomPresentationAnimatorDelegate: class {
    func animationsForAnimator(_ animator: CustomPresentationAnimator) -> (() -> Void)?
}

class CustomPresentationAnimator: NSObject {
    let isPresenting: Bool
    let presentingDuration: TimeInterval
    let presentedDuration: TimeInterval
    fileprivate(set) var fromViewController: UIViewController?
    fileprivate(set) var toViewController: UIViewController?

    fileprivate var finishedAnimations = 0

    init(isPresenting: Bool, duration: TimeInterval) {
        self.isPresenting = isPresenting
        self.presentingDuration = duration
        self.presentedDuration = duration

        super.init()
    }

    init(isPresenting: Bool, presentingDuration: TimeInterval, presentedDuration: TimeInterval) {
        self.isPresenting = isPresenting
        self.presentingDuration = presentingDuration
        self.presentedDuration = presentedDuration

        super.init()
    }
}

extension CustomPresentationAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presentingDuration > presentedDuration ? presentingDuration : presentedDuration
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
        guard
            let fromViewControllerDelegate = fromViewController as? CustomPresentationAnimatorDelegate,
            let fromAnimations = fromViewControllerDelegate.animationsForAnimator(self),
            let toViewControllerDelegate = toViewController as? CustomPresentationAnimatorDelegate,
            let toAnimations = toViewControllerDelegate.animationsForAnimator(self),
            let view = isPresenting ? toViewController.view : fromViewController.view
            else {
                transitionContext.completeTransition(false)
                return
        }

        if isPresenting {
            let containerView = transitionContext.containerView
            containerView.addSubview(view)
            view.frame = containerView.bounds
        }

        UIView.animate(withDuration: presentingDuration, animations: {
            fromAnimations()
        }, completion: { [unowned self] (finished: Bool) in
            self.completion(finished, transitionContext: transitionContext)
        })

        UIView.animate(withDuration: presentedDuration, animations: {
            toAnimations()
        }, completion: { [unowned self] (finished: Bool) in
            self.completion(finished, transitionContext: transitionContext)
        })
    }

    fileprivate func completion(_ finished: Bool, transitionContext: UIViewControllerContextTransitioning) {
        finishedAnimations += 1

        if finishedAnimations == 2 {
            transitionContext.completeTransition(finished)
            if finished {
                fromViewController?.viewDidDisappear(true)
                toViewController?.viewDidAppear(true)
            }
        }
    }
}

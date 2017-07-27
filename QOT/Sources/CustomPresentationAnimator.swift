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
    let duration: TimeInterval
    fileprivate(set) var fromViewController: UIViewController?
    fileprivate(set) var toViewController: UIViewController?
    
    init(isPresenting: Bool, duration: TimeInterval) {
        self.isPresenting = isPresenting
        self.duration = duration
        
        super.init()
    }
}

extension CustomPresentationAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
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
        
        UIView.animate(withDuration: duration, animations: {
            fromAnimations()
            toAnimations()
        }, completion: { (finished: Bool) in
            transitionContext.completeTransition(finished)
            fromViewController.viewDidDisappear(true)
            toViewController.viewDidAppear(true)
        })
    }
}

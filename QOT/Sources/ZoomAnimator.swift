//
//  ZoomAnimator.swift
//  QOT
//
//  Created by Moucheg Mouradian on 19/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ZoomAnimator: NSObject {

    fileprivate let presenting: Bool
    fileprivate let zoomDuration = Animation.zoomDuration
    fileprivate(set) var fromViewController: UIViewController?
    fileprivate(set) var toViewController: UIViewController?
    
    init(isPresentating: Bool) {
        self.presenting = isPresentating

        super.init()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension ZoomAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return zoomDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
        }
        self.fromViewController = fromViewController
        self.toViewController = toViewController

        fromViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)
        
        if presenting {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }

        UIView.animate(withDuration: zoomDuration, animations: {}, completion: { finished in
            if finished {
                fromViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
            }
            transitionContext.completeTransition(finished)
        })
    }
}

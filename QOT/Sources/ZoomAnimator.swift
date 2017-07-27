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

        let toViewController = transitionContext.viewController(forKey: .to)
        let fromViewController = transitionContext.viewController(forKey: .from)

        guard
            let toView = toViewController?.view,
            let fromView = fromViewController?.view
            else { return }

        if presenting {
            containerView.insertSubview(toView, belowSubview: fromView)
        }

        UIView.animate(withDuration: zoomDuration, animations: {}, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}

//
//  ZoomPresentationController.swift
//  QOT
//
//  Created by Moucheg Mouradian on 20/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol ZoomPresentationAnimatable: class {
    func startAnimation(presenting: Bool, animationDuration: TimeInterval, openingFrame: CGRect)
}

final class ZoomPresentationController: UIPresentationController {

    fileprivate let openingFrame: CGRect

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, openingFrame: CGRect) {
        self.openingFrame = openingFrame

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override func presentationTransitionWillBegin() {
        manageTransition(presenting: true)
    }

    override func dismissalTransitionWillBegin() {
        manageTransition(presenting: false)
    }

    private func manageTransition(presenting: Bool) {
        guard
            let presentedCoordinator = presentedViewController.transitionCoordinator,
            let presentedVC = presentedViewController as? ZoomPresentationAnimatable,
            let presentingVC = presentingViewController as? ZoomPresentationAnimatable
            else {
                return
        }

        containerView?.alpha = presenting ? 0 : 1

        presentedCoordinator.animate(alongsideTransition: { [weak self] _ in

            self?.containerView?.alpha = presenting ? 1 : 0
            self?.presentingViewController.view.alpha = presenting ? 0 : 1
        })

        presentedVC.startAnimation(presenting: presenting, animationDuration: Animation.zoomDuration, openingFrame: openingFrame)
        presentingVC.startAnimation(presenting: presenting, animationDuration: Animation.zoomDuration, openingFrame: openingFrame)
    }
}

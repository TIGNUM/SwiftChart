//
//  PartnersAnimation.swift
//  QOT
//
//  Created by Moucheg Mouradian on 19/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class PartnersAnimation: NSObject {

    private let isPresenting: Bool
    private let duration: TimeInterval

    init(isPresenting: Bool, duration: TimeInterval) {
        self.isPresenting = isPresenting
        self.duration = duration
        super.init()
    }

    private func getMyUniverseViewController(_ viewController: UIViewController) -> MyUniverseViewController? {
        if let viewController = viewController as? TabBarController,
            let viewControllers = viewController.viewControllers, viewControllers.count > 1,
            let childViewController = viewControllers[2] as? MyUniverseViewController {
                return childViewController
        }
        return nil
    }

    private func getPartnersViewController(_ viewController: UIViewController) -> PartnersAnimationViewController? {
        if
            let navigationController = viewController as? UINavigationController,
            let childViewController = navigationController.viewControllers.first as? PartnersViewController {
                return childViewController
        } else if
            let navigationController = viewController as? UINavigationController,
            let childViewController = navigationController.viewControllers.first as? PartnersLandingPageViewController {
                return childViewController
        }
        return nil
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension PartnersAnimation: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
        }

        fromViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)

        if isPresenting {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            toViewController.view.frame = containerView.bounds
        }

        let expectedMyUniverseViewController = isPresenting ? fromViewController : toViewController
        let expectedPartnersViewController = isPresenting ? toViewController : fromViewController
        guard
            let myUniverseViewController = getMyUniverseViewController(expectedMyUniverseViewController),
            let partnersViewController = getPartnersViewController(expectedPartnersViewController) else {
                fatalError("missing view controllers for animation")
        }

        if isPresenting {
            partnersViewController.configureForTransitionedState()
            myUniverseViewController.configureForDefaultState()
        } else {
            partnersViewController.configureForDefaultState()
            myUniverseViewController.configureForTransitionedState()
        }

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            if self.isPresenting {
                partnersViewController.configureForDefaultState()
                myUniverseViewController.configureForTransitionedState()
            } else {
                partnersViewController.configureForTransitionedState()
                myUniverseViewController.configureForDefaultState()
            }
        }, completion: { finished in
            partnersViewController.configureForDefaultState()
            myUniverseViewController.configureForDefaultState()
            if finished {
                fromViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
            }
            transitionContext.completeTransition(finished)
        })
    }
}

private extension PartnersAnimationViewController {

    func configureForDefaultState() {
        navigationController?.view.alpha = 1
        view.transform = .identity
    }

    func configureForTransitionedState() {
        navigationController?.view.alpha = 0
        view.transform = CGAffineTransform(translationX: 0.0, y: 100.0)
    }
}

private extension MyUniverseViewController {

    func configureForDefaultState() {
        contentView.partnersWrapperView.transform = .identity
        view.alpha = 1
    }

    func configureForTransitionedState() {
        contentView.partnersWrapperView.transform = CGAffineTransform(translationX: 200.0, y: -300.0).scaledBy(x: 2.5, y: 2.5)
        view.alpha = 0
    }
}

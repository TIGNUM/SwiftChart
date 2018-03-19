//
//  MyToBeVisionAnimation.swift
//  QOT
//
//  Created by Moucheg Mouradian on 19/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MyToBeVisionAnimation: NSObject {

    private let isPresenting: Bool
    private let duration: TimeInterval

    init(isPresenting: Bool, duration: TimeInterval) {
        self.isPresenting = isPresenting
        self.duration = duration
        super.init()
    }

    private func getMyUniverseViewController(_ viewController: UIViewController) -> MyUniverseViewController? {
        if
            let viewController = viewController as? TabBarController,
            let viewControllers = viewController.viewControllers, viewControllers.count > 1,
            let childViewController = viewControllers[2] as? MyUniverseViewController {
                return childViewController
        }
        return nil
    }

    private func getMyToBeVisionViewController(_ viewController: UIViewController) -> MyToBeVisionViewController? {
        if
            let navigationController = viewController as? UINavigationController,
            let childViewController = navigationController.viewControllers.first as? MyToBeVisionViewController {
            return childViewController
        }
        return nil
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension MyToBeVisionAnimation: UIViewControllerAnimatedTransitioning {

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
        let expectedMyToBeVisionViewController = isPresenting ? toViewController : fromViewController
        guard
            let myUniverseViewController = getMyUniverseViewController(expectedMyUniverseViewController),
            let myToBeVisionViewController = getMyToBeVisionViewController(expectedMyToBeVisionViewController) else {
                fatalError("missing view controllers for animation")
        }

        if isPresenting {
            myToBeVisionViewController.configureForTransitionedState()
            myUniverseViewController.configureForDefaultState()
        } else {
            myToBeVisionViewController.configureForDefaultState()
            myUniverseViewController.configureForTransitionedState()
        }

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            if self.isPresenting {
                myToBeVisionViewController.configureForDefaultState()
                myUniverseViewController.configureForTransitionedState()
            } else {
                myToBeVisionViewController.configureForTransitionedState()
                myUniverseViewController.configureForDefaultState()
            }
        }, completion: { finished in
            myUniverseViewController.configureForDefaultState()
            myToBeVisionViewController.configureForDefaultState()
            if finished {
                fromViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
            }
            transitionContext.completeTransition(finished)
        })
    }
}

private extension MyToBeVisionViewController {

    func configureForDefaultState() {
        view.alpha = 1
    }

    func configureForTransitionedState() {
        view.alpha = 0
    }
}

private extension MyUniverseViewController {

    func configureForDefaultState() {
        contentView.profileWrapperView.transform = .identity
        contentView.visionWrapperView.transform = .identity
        contentView.weeklyChoicesWrapperView.transform = .identity
        contentView.partnersWrapperView.transform = .identity
        view.alpha = 1
    }

    func configureForTransitionedState() {
        contentView.profileWrapperView.transform = CGAffineTransform(translationX: 90.0, y: 260.0).scaledBy(x: 4.0, y: 3.0)
        contentView.visionWrapperView.transform = CGAffineTransform(translationX: -120.0, y: 20.0)
        contentView.weeklyChoicesWrapperView.transform = CGAffineTransform(translationX: 100.0, y: 10.0)
        contentView.partnersWrapperView.transform = CGAffineTransform(translationX: 10.0, y: 100.0)
        view.alpha = 0
    }
}

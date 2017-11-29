//
//  ChartAnimation.swift
//  QOT
//
//  Created by Moucheg Mouradian on 19/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ChartAnimation: NSObject {

    private let isPresenting: Bool
    private let duration: TimeInterval

    init(isPresenting: Bool, duration: TimeInterval) {
        self.isPresenting = isPresenting
        self.duration = duration
        super.init()
    }

    private func getMyUniverseViewController(_ viewController: UIViewController) -> MyUniverseViewController? {
        if let viewController = viewController as? TabBarController, let viewControllers = viewController.viewControllers, viewControllers.count > 1, let childViewController = viewControllers[1] as? MyUniverseViewController {
            return childViewController
        }
        return nil
    }

    private func getChartViewController(_ viewController: UIViewController) -> ChartViewController? {
        if let navigationController = viewController as? UINavigationController, let pageViewController = navigationController.viewControllers.first as? PageViewController, let childViewController = pageViewController.viewControllers?.first as? ChartViewController {
            return childViewController
        }
        return nil
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension ChartAnimation: UIViewControllerAnimatedTransitioning {

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
        let expectedChartViewController = isPresenting ? toViewController : fromViewController
        guard
            let myUniverseViewController = getMyUniverseViewController(expectedMyUniverseViewController),
            let chartViewController = getChartViewController(expectedChartViewController) else {
                fatalError("missing view controllers for animation")
        }

        if isPresenting {
            chartViewController.configureForTransitionedState()
            myUniverseViewController.configureForDefaultState()
        } else {
            chartViewController.configureForDefaultState()
            myUniverseViewController.configureForTransitionedState()
        }

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            if self.isPresenting {
                chartViewController.configureForDefaultState()
                myUniverseViewController.configureForTransitionedState()
            } else {
                chartViewController.configureForTransitionedState()
                myUniverseViewController.configureForDefaultState()
            }
        }, completion: { finished in
            if finished {
                fromViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
            }
            chartViewController.configureForDefaultState()
            myUniverseViewController.configureForDefaultState()
            transitionContext.completeTransition(finished)
        })
    }
}

private extension ChartViewController {

    func configureForDefaultState() {
        navigationController?.view.alpha = 1
    }

    func configureForTransitionedState() {
        navigationController?.view.alpha = 0
    }
}

private extension MyUniverseViewController {

    func configureForDefaultState() {
        view.alpha = 1
        view.transform = CGAffineTransform(scaleX: 1, y: 1)
        view.transform = CGAffineTransform(scaleX: 1, y: 1)
    }

    func configureForTransitionedState() {
        view.alpha = 0
        view.transform = CGAffineTransform(scaleX: 1, y: 1)
        view.transform = CGAffineTransform(scaleX: 3, y: 3)
    }
}

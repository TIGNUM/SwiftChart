//
//  WeeklyChoicesAnimation.swift
//  QOT
//
//  Created by Moucheg Mouradian on 19/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class WeeklyChoicesAnimation: NSObject {

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
    
    private func getWeeklyChoicesViewController(_ viewController: UIViewController) -> WeeklyChoicesViewController? {
        if let navigationController = viewController as? UINavigationController, let pageViewController = navigationController.viewControllers.first as? PageViewController, let childViewController = pageViewController.viewControllers?.first as? WeeklyChoicesViewController {
            return childViewController
        }
        return nil
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension WeeklyChoicesAnimation: UIViewControllerAnimatedTransitioning {

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
        let expectedWeeklyChoicesViewController = isPresenting ? toViewController : fromViewController
        guard
            let myUniverseViewController = getMyUniverseViewController(expectedMyUniverseViewController),
            let weeklyChoicesViewController = getWeeklyChoicesViewController(expectedWeeklyChoicesViewController) else {
                fatalError("missing view controllers for animation")
        }
        
        if isPresenting {
            weeklyChoicesViewController.configureForTransitionedState()
            myUniverseViewController.configureForDefaultState()
        } else {
            weeklyChoicesViewController.configureForDefaultState()
            myUniverseViewController.configureForTransitionedState()
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            if self.isPresenting {
                weeklyChoicesViewController.configureForDefaultState()
                myUniverseViewController.configureForTransitionedState()
            } else {
                weeklyChoicesViewController.configureForTransitionedState()
                myUniverseViewController.configureForDefaultState()
            }
        }, completion: { finished in
            if finished {
                fromViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
            }
            weeklyChoicesViewController.configureForDefaultState()
            myUniverseViewController.configureForDefaultState()
            transitionContext.completeTransition(finished)
        })
    }
}

private extension WeeklyChoicesViewController {
    
    func configureForDefaultState() {
        navigationController?.view.alpha = 1
    }
    
    func configureForTransitionedState() {
        navigationController?.view.alpha = 0
    }
}

private extension MyUniverseViewController {
    
    func configureForDefaultState() {
        myWhyView.myToBeVisionBox.transform = .identity
        myWhyView.weeklyChoicesBox.transform = .identity
        myWhyView.qotPartnersBox.transform = .identity
        view.transform = .identity
        view.alpha = 1
    }
    
    func configureForTransitionedState() {
        myWhyView.myToBeVisionBox.transform = CGAffineTransform(translationX: -120.0, y: -50.0)
        myWhyView.weeklyChoicesBox.transform = CGAffineTransform(translationX: 100.0, y: 10.0)
        myWhyView.qotPartnersBox.transform = CGAffineTransform(translationX: -120.0, y: -50.0)
        view.transform = CGAffineTransform(translationX: -580.0, y: -50.0).scaledBy(x: 4.0, y: 3.0)
        view.alpha = 0
    }
}

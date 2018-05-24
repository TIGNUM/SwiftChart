//
//  LearnListAnimation.swift
//  QOT
//
//  Created by Moucheg Mouradian on 19/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnListAnimation: NSObject {

    private let upScale: CGFloat = 1.3
    private let isPresenting: Bool
    private let duration: TimeInterval

    init(isPresenting: Bool, duration: TimeInterval) {
        self.isPresenting = isPresenting
        self.duration = duration

        super.init()
    }

    // MARK: - private

    private func getLearnCategoryListViewController(_ viewController: UIViewController) -> LearnCategoryListViewController? {
        if
            let viewController = viewController as? TabBarController,
            let viewControllers = viewController.viewControllers,
            let navigationController = viewControllers[1] as? UINavigationController,
            let pageViewController = navigationController.viewControllers.first as? PageViewController,
            let childViewController = pageViewController.viewControllers?.first as? LearnCategoryListViewController {
                return childViewController
        }

        return nil
    }

    private func getLearnContentListViewController(_ navigationController: UINavigationController?) -> LearnContentListViewController? {
        return (navigationController?.viewControllers.first as? PageViewController)?.viewControllers?.first as? LearnContentListViewController
    }

    private func animate(_ learnCategoryListViewController: LearnCategoryListViewController,
                         _ learnContentListViewController: LearnContentListViewController) {
        learnContentListViewController.view.alpha = isPresenting ? 1 : 0
        learnCategoryListViewController.collectionView.transform = isPresenting ? CGAffineTransform(scaleX: upScale, y: upScale) : .identity
        learnCategoryListViewController.view.layoutIfNeeded()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension LearnListAnimation: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
        }

        fromViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)

        if isPresenting == true {
            let containerView = transitionContext.containerView
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            toViewController.view.frame = containerView.bounds
        }

        let expectedTabBarController = isPresenting ? fromViewController : toViewController
        let expectedViewController = isPresenting ? toViewController : fromViewController

        guard
            let learnCategoryListViewController = getLearnCategoryListViewController(expectedTabBarController),
            let learnContentListViewController = getLearnContentListViewController(expectedViewController as? UINavigationController) else {
                fatalError("missing view controllers for animation")
        }

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            self.animate(learnCategoryListViewController, learnContentListViewController)
        }, completion: { (finished: Bool) in
            if finished == true {
                fromViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
            }
            transitionContext.completeTransition(finished)
        })
    }
}

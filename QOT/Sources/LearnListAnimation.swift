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

    private func getTabBarController(_ viewController: UIViewController) -> TabBarController? {
        if let viewController = viewController as? TabBarController { return viewController }

        return nil
    }

    private func getLearnCategoryListViewController(_ viewController: UIViewController) -> LearnCategoryListViewController? {
        if
            let viewController = viewController as? TabBarController,
            let viewControllers = viewController.viewControllers,
            let navigationController = viewControllers.first as? UINavigationController,
            let pageViewController = navigationController.viewControllers.first as? PageViewController,
            let childViewController = pageViewController.viewControllers?.first as? LearnCategoryListViewController {
                return childViewController
        }

        return nil
    }

    private func getLearnContentListViewController(_ viewController: UIViewController) -> LearnContentListViewController? {
        if let viewController = viewController as? LearnContentListViewController { return viewController }

        return nil
    }

    private func prepare(_ tabBarController: TabBarController,
                         _ learnCategoryListViewController: LearnCategoryListViewController,
                         _ learnContentListViewController: LearnContentListViewController) {
        tabBarController.view.layoutIfNeeded()
        tabBarController.view.alpha = isPresenting ? 1 : 0
        let labelheight = learnContentListViewController.performanceLabelSize.height
        let cellHeight = learnContentListViewController.pagingCellSize.height
        let constraintValue = labelheight + cellHeight
        learnContentListViewController.pagingCollectionViewTopConstraint?.constant = isPresenting ? -constraintValue : 0
        learnContentListViewController.pagingCollectionViewBottomConstraint?.constant = isPresenting ? 0 : constraintValue
        let bottomConstraint = tabBarController.tabBar.frame.height
        learnContentListViewController.getBackButtonBottomConstraint?.constant = isPresenting ? bottomConstraint : 0
        learnContentListViewController.view.layoutIfNeeded()
        learnContentListViewController.view.alpha = isPresenting ? 0 : 1

        if isPresenting == false {
            learnCategoryListViewController.collectionView.reloadData()
        }
    }

    private func animate(_ tabBarController: TabBarController,
                         _ learnCategoryListViewController: LearnCategoryListViewController,
                         _ learnContentListViewController: LearnContentListViewController) {
        let tabBarFrame = tabBarController.tabBar.frame
        let offsetY = isPresenting ? tabBarFrame.height : -tabBarFrame.height
        tabBarController.tabBar.frame = tabBarFrame.offsetBy(dx: 0, dy: offsetY)
        tabBarController.view.layoutIfNeeded()
        tabBarController.view.alpha = isPresenting ? 0 : 1
        let labelHeight = learnContentListViewController.performanceLabelSize.height
        let cellHeight = learnContentListViewController.pagingCellSize.height
        let constraintValue = labelHeight + cellHeight
        learnContentListViewController.pagingCollectionViewTopConstraint?.constant = isPresenting ? 0 : -constraintValue
        learnContentListViewController.pagingCollectionViewBottomConstraint?.constant = isPresenting ? constraintValue : 0
        let bottomConstraint = tabBarController.tabBar.frame.height
        learnContentListViewController.getBackButtonBottomConstraint?.constant = isPresenting ? 0 : bottomConstraint
        learnContentListViewController.view.layoutIfNeeded()
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
            let tabBarController = getTabBarController(expectedTabBarController),
            let learnCategoryListViewController = getLearnCategoryListViewController(expectedTabBarController),
            let learnContentListViewController = getLearnContentListViewController(expectedViewController) else {
                fatalError("missing view controllers for animation")
        }

        prepare(tabBarController, learnCategoryListViewController, learnContentListViewController)

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            self.animate(tabBarController, learnCategoryListViewController, learnContentListViewController)
        }, completion: { (finished: Bool) in
            if finished == true {
                fromViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
            }
            transitionContext.completeTransition(finished)
        })
    }
}

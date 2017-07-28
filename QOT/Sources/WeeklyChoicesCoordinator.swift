//
//  WeeklyChoicesCoordinator.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class WeeklyChoicesCoordinator: NSObject, ParentCoordinator {

    // MARK: - Properties

    fileprivate let rootViewController: UIViewController
    fileprivate let services: Services

    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services) {
        self.rootViewController = root
        self.services = services
    }

    func start() {
        let viewModel = WeeklyChoicesViewModel(services: services)
        let weeklyChoicesViewController = WeeklyChoicesViewController(viewModel: viewModel)
        weeklyChoicesViewController.delegate = self

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [weeklyChoicesViewController],
            themes: [.darkClear],
            titles: [R.string.localized.meSectorMyWhyWeeklyChoicesTitle()]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,            
            leftIcon: R.image.ic_minimize()
        )

        topTabBarController.delegate = self
        topTabBarController.modalPresentationStyle = .custom
        topTabBarController.transitioningDelegate = self

        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - WeeklyChoicesViewControllerDelegate

extension WeeklyChoicesCoordinator: WeeklyChoicesViewControllerDelegate {

    func didTapClose(in viewController: UIViewController, animated: Bool) {
        viewController.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

    func didTapShare(in viewController: UIViewController, from rect: CGRect, with item: WeeklyChoice) {
        log("didTapShare in: \(viewController), from rect: \(rect ) with item: \(item)")
    }
}

extension WeeklyChoicesCoordinator: TopTabBarDelegate {

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print(index as Any, sender)
    }

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print(sender)
    }

}

// MARK: - UIViewControllerTransitioningDelegate

extension WeeklyChoicesCoordinator: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return CustomPresentationAnimator(isPresenting: true, duration: 0.5)
        return CustomPresentationAnimator(isPresenting: true, presentingDuration: 0.5, presentedDuration: 0.3)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return CustomPresentationAnimator(isPresenting: false, duration: 0.5)
        return CustomPresentationAnimator(isPresenting: false, presentingDuration: 0.3, presentedDuration: 0.5)
    }
}

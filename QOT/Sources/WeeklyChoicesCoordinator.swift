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

    fileprivate let services: Services
    fileprivate let weeklyChoicesViewController: WeeklyChoicesViewController
    fileprivate var topTabBarController: UINavigationController!
    fileprivate let rootViewController: UIViewController
    private weak var weeklyChoicesDelegate: WeeklyChoicesViewModelDelegate?
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services) {
        self.rootViewController = root
        self.services = services
        let viewModel = WeeklyChoicesViewModel(services: services)
        weeklyChoicesViewController = WeeklyChoicesViewController(viewModel: viewModel)
        weeklyChoicesDelegate = viewModel
        weeklyChoicesViewController.title = R.string.localized.meSectorMyWhyWeeklyChoicesTitle()

        super.init()

        let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize())
        let rightButton = viewModel.itemCount == 0 ? UIBarButtonItem(withImage: R.image.prepareContentPlusIcon()) : nil
        topTabBarController = UINavigationController(withPages: [weeklyChoicesViewController], topBarDelegate: self, leftButton: leftButton, rightButton: rightButton)
        topTabBarController.modalPresentationStyle = .custom
        topTabBarController.transitioningDelegate = self
        weeklyChoicesViewController.delegate = self
    }

    func start() {
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

    func didUpdateList(with viewModel: WeeklyChoicesViewModel) {
        let rightButton = viewModel.itemCount == 0 ? UIBarButtonItem(withImage: R.image.prepareContentPlusIcon()) : nil
        topTabBarController.navigationBar.topItem?.rightBarButtonItem = rightButton
    }
}

// MARK: - TopNavigationBarDelegate

extension WeeklyChoicesCoordinator: TopNavigationBarDelegate {

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismiss(animated: true, completion: nil)
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
        let launchHandler = LaunchHandler()
        launchHandler.weeklyChoiches { [unowned self] in
            self.weeklyChoicesDelegate?.fetchWeeklyChoices()
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension WeeklyChoicesCoordinator: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentationAnimator(isPresenting: true, presentingDuration: 0.5, presentedDuration: 0.3)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentationAnimator(isPresenting: false, presentingDuration: 0.3, presentedDuration: 0.5)
    }
}

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

    private let rootViewController: UIViewController
    private let services: Services
    private let weeklyChoicesViewController: WeeklyChoicesViewController
    private let transitioningDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate
    private weak var weeklyChoicesDelegate: WeeklyChoicesViewModelDelegate?
    var children: [Coordinator] = []
    var topTabBarController: UINavigationController!

    // MARK: - Life Cycle

    init(root: UIViewController,
         services: Services,
         transitioningDelegate: UIViewControllerTransitioningDelegate?,
         topBarDelegate: TopNavigationBarDelegate?) {
        self.rootViewController = root
        self.services = services
        self.transitioningDelegate = transitioningDelegate
        let viewModel = WeeklyChoicesViewModel(services: services)
        weeklyChoicesViewController = WeeklyChoicesViewController(viewModel: viewModel)
        weeklyChoicesDelegate = viewModel
        weeklyChoicesViewController.title = R.string.localized.meSectorMyWhyWeeklyChoicesTitle()

        super.init()

        let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize())
        let rightButton = viewModel.itemCount == 0 ? UIBarButtonItem(withImage: R.image.prepareContentPlusIcon()) : nil
        topTabBarController = UINavigationController(withPages: [weeklyChoicesViewController],
                                                     topBarDelegate: topBarDelegate ?? self,
                                                     leftButton: leftButton,
                                                     rightButton: rightButton)
        topTabBarController.modalPresentationStyle = .custom
        if transitioningDelegate != nil {
            topTabBarController.transitioningDelegate = transitioningDelegate
        }
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

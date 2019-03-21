//
//  MyStatisticsCoordinator.swift
//  QOT
//
//  Created by karmic on 11.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class StatisticsCoordinator: NSObject, ParentCoordinator {

    // MARK: - Properties

    private let rootViewController: UIViewController
    private let services: Services
    private let permissionsManager: PermissionsManager
    private let transitioningDelegate: UIViewControllerTransitioningDelegate // swiftlint:disable:this weak_delegate
    private let startingSection: StatisticsSectionType
    private let pageTracker: PageTracker
    private var topTabBarController: UINavigationController!
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController,
         services: Services,
         transitioningDelegate: UIViewControllerTransitioningDelegate,
         startingSection: StatisticsSectionType? = nil,
         permissionsManager: PermissionsManager,
         pageTracker: PageTracker) {
        self.pageTracker = pageTracker
        self.rootViewController = root
        self.services = services
        self.transitioningDelegate = transitioningDelegate
        self.startingSection = startingSection ?? .sleep
        self.permissionsManager = permissionsManager
    }

    func start() {
        let viewModel = ChartViewModel(services: services,
                                       permissionsManager: permissionsManager,
                                       startingSection: startingSection,
                                       pageTracker: pageTracker)
        let statisticsViewController = ChartViewController(viewModel: viewModel)
        statisticsViewController.title = R.string.localized.tabBarItemData()
        topTabBarController = UINavigationController(withPages: [statisticsViewController],
                                                     navigationItem: NavigationItem(),
                                                     topBarDelegate: self,
                                                     leftButton: UIBarButtonItem(withImage: R.image.ic_minimize()))
        topTabBarController.modalPresentationStyle = .custom
        topTabBarController.transitioningDelegate = transitioningDelegate
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - TopNavigationBarDelegate

extension StatisticsCoordinator: NavigationItemDelegate {

    func navigationItem(_ navigationItem: NavigationItem, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismiss(animated: true, completion: nil)
    }

    func navigationItem(_ navigationItem: NavigationItem, middleButtonPressedAtIndex index: Int, ofTotal total: Int) {}

    func navigationItem(_ navigationItem: NavigationItem, rightButtonPressed button: UIBarButtonItem) {}

    func navigationItem(_ navigationItem: NavigationItem, searchButtonPressed button: UIBarButtonItem) {}
}

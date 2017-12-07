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
    private var topTabBarController: UINavigationController!
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController,
         services: Services,
         transitioningDelegate: UIViewControllerTransitioningDelegate,
         startingSection: StatisticsSectionType? = nil,
         permissionsManager: PermissionsManager) {
        self.rootViewController = root
        self.services = services
        self.transitioningDelegate = transitioningDelegate
        self.startingSection = startingSection ?? .sleep
        self.permissionsManager = permissionsManager
    }

    func start() {
        do {
            let viewModel = try ChartViewModel(services: services, permissionsManager: permissionsManager, startingSection: startingSection)
            let statisticsViewController = ChartViewController(viewModel: viewModel)            
            statisticsViewController.title = R.string.localized.meMyStatisticsNavigationBarTitle()
            topTabBarController = UINavigationController(withPages: [statisticsViewController],
                                                         topBarDelegate: self,
                                                         leftButton: UIBarButtonItem(withImage: R.image.ic_minimize()))
            topTabBarController.modalPresentationStyle = .custom
            topTabBarController.transitioningDelegate = transitioningDelegate
            rootViewController.present(topTabBarController, animated: true)
        } catch let error {
            assertionFailure("Failed to fetch cards with error: \(error)")
        }
    }
}

// MARK: - TopNavigationBarDelegate

extension StatisticsCoordinator: TopNavigationBarDelegate {

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismiss(animated: true, completion: nil)
    }

    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
    }

    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
    }
}

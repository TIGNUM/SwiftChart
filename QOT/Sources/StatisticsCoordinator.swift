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

    fileprivate let rootViewController: UIViewController
    fileprivate let services: Services
    fileprivate let transitioningDelegate: UIViewControllerTransitioningDelegate // swiftlint:disable:this weak_delegate
    fileprivate let startingSection: StatisticsSectionType
    fileprivate var topTabBarController: UINavigationController!
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services, transitioningDelegate: UIViewControllerTransitioningDelegate, startingSection: StatisticsSectionType? = nil) {
        self.rootViewController = root
        self.services = services
        self.transitioningDelegate = transitioningDelegate
        self.startingSection = startingSection ?? .sleep
    }

    func start() {
        do {
            let viewModel = try ChartViewModel(services: services, startingSection: startingSection)
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

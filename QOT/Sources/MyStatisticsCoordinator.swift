//
//  MyStatisticsCoordinator.swift
//  QOT
//
//  Created by karmic on 11.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class MyStatisticsCoordinator: ParentCoordinator {

    // MARK: - Properties

    fileprivate let rootViewController: UIViewController
    fileprivate let services: Services
    fileprivate var topTabBarController: UINavigationController!
    
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services) {
        self.rootViewController = root
        self.services = services
    }

    func start() {
        do {
            let viewModel = try MyStatisticsViewModel(services: services)
            let myStatisticsViewController = MyStatisticsViewController(viewModel: viewModel)
            myStatisticsViewController.delegate = self
            myStatisticsViewController.title = "23 SEP // 30 Sep" //TODO: localise
   
            let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize())
            topTabBarController = UINavigationController(withPages: [myStatisticsViewController], topBarDelegate: self, leftButton: leftButton)

            rootViewController.present(topTabBarController, animated: true)
        } catch let error {
            assertionFailure("Failed to fetch cards with error: \(error)")
        }
    }
}

// MARK: - MyStatisticsViewControllerDelegate

extension MyStatisticsCoordinator: MyStatisticsViewControllerDelegate {

    func didSelectStatitcsCard(in section: Index, at index: Index, from viewController: MyStatisticsViewController) {
        print("didSelectStatitcsCard", section, index, viewController)
    }
}

// MARK: - TopNavigationBarDelegate

extension MyStatisticsCoordinator: TopNavigationBarDelegate {
    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismiss(animated: true, completion: nil)
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
    }
}

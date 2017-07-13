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
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services) {
        self.rootViewController = root
        self.services = services
    }

    func start() {
        do {
            let cards = try services.myStatisticsService.cards()
            let viewModel = MyStatisticsViewModel(cards: cards)
            let myStatisticsViewController = MyStatisticsViewController(viewModel: viewModel)
            myStatisticsViewController.delegate = self

            let topTabBarControllerItem = TopTabBarController.Item(
                controllers: [myStatisticsViewController],
                themes: [.darkClear],
                titles: ["23 SEP // 30 Sep"]
            )

            let topTabBarController = TopTabBarController(
                item: topTabBarControllerItem,
                leftIcon: R.image.ic_minimize()
            )

            topTabBarController.delegate = self
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

// MARK: - TopTabBarDelegate

extension MyStatisticsCoordinator: TopTabBarDelegate {

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectRightButton", sender)
    }

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print("didSelectItemAtIndex", index as Any, sender)
    }
}

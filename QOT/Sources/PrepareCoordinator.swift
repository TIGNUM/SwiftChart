//
//  RootPrepareCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 29.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class PrepareCoordinator: ParentCoordinator {

    // MARK: Private properties

    fileprivate let services: Services
    fileprivate let tabBarController: TabBarController
    fileprivate let topTabBarController: TopTabBarController
    fileprivate let chatViewController: ChatViewController<Answer>
    fileprivate let chatDecisionManager: PrepareChatDecisionManager

    var children = [Coordinator]()

    init(services: Services,
         tabBarController: TabBarController,
         topTabBarController: TopTabBarController,
         chatViewController: ChatViewController<Answer>) {
        self.services = services
        self.tabBarController = tabBarController
        self.topTabBarController = topTabBarController
        self.chatViewController = chatViewController
        self.chatDecisionManager = PrepareChatDecisionManager(service: services.questionsService)

        chatDecisionManager.delegate = self
        chatViewController.didSelectChoice = { [weak self] (choice, viewController) in
            self?.chatDecisionManager.didSelectChoice(choice)
        }
    }

    func start() {

    }

    func focus() {
        chatDecisionManager.start()
    }
}

extension PrepareCoordinator : PrepareChatDecisionManagerDelegate {

    func setItems(_ items: [ChatItem<Answer>], manager: PrepareChatDecisionManager) {
        chatViewController.viewModel.setItems(items: items)
    }

    func appendItems(_ items: [ChatItem<Answer>], manager: PrepareChatDecisionManager) {
        chatViewController.viewModel.append(items: items)
    }

    func showContent(id: Int, manager: PrepareChatDecisionManager) {
        let coordinator = PrepareContentCoordinator(root: tabBarController, services: services, eventTracker: services.trackingService)
        coordinator.delagate = self
        startChild(child: coordinator)
    }
}

extension PrepareCoordinator: PrepareContentCoordinatorDelegate {
    func prepareContentDidFinish(coordinator: PrepareContentCoordinator) {
        removeChild(child: coordinator)
        chatDecisionManager.repeatFlow()
    }
}

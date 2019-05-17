//
//  CoachRouter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class CoachRouter {

    // MARK: - Properties

    private let viewController: CoachViewController
    private let services: Services
    weak var delegate: CoachCollectionViewControllerDelegate?

    // MARK: - Init

    init(viewController: CoachViewController, services: Services) {
        self.viewController = viewController
        self.services = services
    }
}

// MARK: - CoachRouterInterface

extension CoachRouter: CoachRouterInterface {

    func handleTap(coachSection: CoachSection) {
        switch coachSection {
        case .search:
            let configurator = SearchConfigurator.make(delegate: delegate)
            let searchViewController = SearchViewController(configure: configurator, pageName: .sideBarSearch)
            let navController = UINavigationController(rootViewController: searchViewController)
            navController.navigationBar.applyDefaultStyle()
            navController.modalTransitionStyle = .crossDissolve
            viewController.pushToStart(childViewController: searchViewController)
            print ("search")
        case .tools:
            print("tools")
        case .sprint:
            print("sprint")
        case .event:
            print("event")
        case .challenge:
            print("challenge")
        }
    }
}

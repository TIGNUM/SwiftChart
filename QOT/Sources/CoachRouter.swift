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
    weak var delegate: CoachCollectionViewControllerDelegate?

    // MARK: - Init

    init(viewController: CoachViewController) {
        self.viewController = viewController
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
        case .tools:
            let storyboardID = R.storyboard.tools.toolsViewControllerID.identifier
            let toolsViewController = R.storyboard
                .tools().instantiateViewController(withIdentifier: storyboardID) as? ToolsViewController
            if let toolsViewController = toolsViewController {
                ToolsConfigurator.make(viewController: toolsViewController)
                viewController.pushToStart(childViewController: toolsViewController)
            }
        case .sprint:
            print("sprint")
        case .event:
            print("event")
        case .challenge:
            print("challenge")
        }
    }
}

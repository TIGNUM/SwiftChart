//
//  CoachRouter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class CoachRouter {

    // MARK: - Properties
    private let viewController: CoachViewController
    weak var delegate: CoachCollectionViewControllerDelegate?
    private var permissionsManager: PermissionsManager {
        return AppCoordinator.permissionsManager!
    }

    // MARK: - Init
    init(viewController: CoachViewController) {
        self.viewController = viewController
    }
}

// MARK: - CoachRouterInterface
extension CoachRouter: CoachRouterInterface {
    func handleTap(coachSection: CoachSection) {
        NotificationCenter.default.post(name: .updateBottomNavigation,
                                        object: BottomNavigationItem(leftBarButtonItems: [],
                                                                     rightBarButtonItems: [], backgroundColor: .clear),
                                        userInfo: nil)
        switch coachSection {
        case .search:
            let configurator = SearchConfigurator.make(delegate: delegate)
            let searchViewController = SearchViewController(configure: configurator)
            let navController = UINavigationController(rootViewController: searchViewController)
            navController.navigationBar.applyDefaultStyle()
            navController.modalTransitionStyle = .crossDissolve
            viewController.pushToStart(childViewController: searchViewController)
            searchViewController.activate(0.0)
        case .tools:
            let storyboardID = R.storyboard.tools.toolsViewControllerID.identifier
            let toolsViewController = R.storyboard
                .tools().instantiateViewController(withIdentifier: storyboardID) as? ToolsViewController
            if let toolsViewController = toolsViewController {
                ToolsConfigurator.make(viewController: toolsViewController)
                viewController.present(toolsViewController, animated: true, completion: nil)
            }
        case .sprint:
            let configurator = DTSprintConfigurator.make()
            let controller = DTSprintViewController(configure: configurator)
            viewController.present(controller, animated: true)
        case .event:
            let configurator = DTShortTBVConfigurator.make(introKey: ShortTBV.QuestionKey.IntroMindSet)
            let controller = DTShortTBVViewController(configure: configurator)
            viewController.present(controller, animated: true)
        case .challenge:
            let configurator = DTMindsetConfigurator.make()
            let controller = DTMindsetViewController(configure: configurator)
            viewController.present(controller, animated: true)
        case .shortTBVMindSet:
            let configurator = DTShortTBVConfigurator.make(introKey: ShortTBV.QuestionKey.IntroMindSet)
            let controller = DTShortTBVViewController(configure: configurator)
            viewController.present(controller, animated: true)
        case .shortTBVPrepare:
            let configurator = DTShortTBVConfigurator.make(introKey: ShortTBV.QuestionKey.IntroPrepare)
            let controller = DTShortTBVViewController(configure: configurator)
            viewController.present(controller, animated: true)
        case .shortTBVOnBoarding:
            let configurator = DTShortTBVConfigurator.make(introKey: ShortTBV.QuestionKey.IntroOnboarding)
            let controller = DTShortTBVViewController(configure: configurator)
            viewController.present(controller, animated: true)
        }
    }
}

// MARK: - Private
private extension CoachRouter {
    func presentDecisionTree(_ type: DecisionTreeType) {
        let configurator = DecisionTreeConfigurator.make(for: type)
        let controller = DecisionTreeViewController(configure: configurator)
        viewController.present(controller, animated: true)
    }
}

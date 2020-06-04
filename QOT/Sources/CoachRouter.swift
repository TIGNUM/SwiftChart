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
    private weak var viewController: CoachViewController?
    weak var delegate: CoachCollectionViewControllerDelegate?

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
                                                                     rightBarButtonItems: [],
                                                                     backgroundColor: .clear),
                                        userInfo: nil)
        switch coachSection {
        case .search:
            let configurator = SearchConfigurator.make(delegate: delegate)
            let searchViewController = SearchViewController(configure: configurator)
            viewController?.pushToStart(childViewController: searchViewController)
            searchViewController.activate(0.0)
        case .tools:
            if UserDefault.toolsExplanation.boolValue {
                let toolsViewController = R.storyboard.tools.toolsViewControllerID()
                if let toolsViewController = toolsViewController {
                    ToolsConfigurator.make(viewController: toolsViewController)
                    viewController?.present(toolsViewController, animated: true, completion: nil)
                }
            } else {
                showFeatureExplanation(.tools)
            }
        case .sprint:
            if UserDefault.sprintExplanation.boolValue {
                let configurator = DTSprintConfigurator.make()
                let controller = DTSprintViewController(configure: configurator)
                viewController?.present(controller, animated: true)
            } else {
                showFeatureExplanation(.sprint)
            }
        case .event:
            if UserDefault.prepareExplanation.boolValue {
                if let launchURL = URLScheme.prepareEvent.launchURLWithParameterValue("") {
                    AppDelegate.current.launchHandler.process(url: launchURL)
                }
            } else {
               showFeatureExplanation(.solve)
            }
        case .challenge:
            if UserDefault.solveExplanation.boolValue {
                let configurator = DTSolveConfigurator.make()
                let controller = DTSolveViewController(configure: configurator)
                viewController?.present(controller, animated: true)
            } else {
                showFeatureExplanation(.solve)
            }
        case .mindset:
            if UserDefault.mindsetExplanation.boolValue {
                let configurator = DTMindsetConfigurator.make()
                let controller = DTMindsetViewController(configure: configurator)
                viewController?.present(controller, animated: true)
            } else {
               showFeatureExplanation(.mindsetShifter)
            }
        case .recovery:
            if UserDefault.recoveryExplanation.boolValue {
                let configurator = DTRecoveryConfigurator.make()
                let controller = DTRecoveryViewController(configure: configurator)
                viewController?.present(controller, animated: true)
            } else {
                showFeatureExplanation(.recovery)
            }
        }
    }

    func showFeatureExplanation(_ type: FeatureExplainer.Kind) {
        guard let controller = R.storyboard.featureExplainer().instantiateInitialViewController() as?
            FeatureExplainerViewController else { return }
        FeatureExplainerConfigurator.make(viewController: controller, type: type)
        viewController?.present(controller, animated: true, completion: nil)
    }
}

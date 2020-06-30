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
        var tempViewControllerToPresent: UIViewController?
        switch coachSection {
        case .search:
            let configurator = SearchConfigurator.make(delegate: delegate)
            let searchViewController = SearchViewController(configure: configurator)
            viewController?.pushToStart(childViewController: searchViewController)
            searchViewController.activate(0.0)
        case .tools where UserDefault.toolsExplanation.boolValue:
            guard let toolsViewController = R.storyboard.tools.toolsViewControllerID() else { break }
            ToolsConfigurator.make(viewController: toolsViewController)
            tempViewControllerToPresent = toolsViewController
        case .sprint where UserDefault.sprintExplanation.boolValue:
            let configurator = DTSprintConfigurator.make()
            let controller = DTSprintViewController(configure: configurator)
            tempViewControllerToPresent = controller
        case .event where UserDefault.prepareExplanation.boolValue:
            guard let launchURL = URLScheme.prepareEvent.launchURLWithParameterValue("") else { break }
            AppDelegate.current.launchHandler.process(url: launchURL)
        case .challenge where UserDefault.solveExplanation.boolValue:
            let configurator = DTSolveConfigurator.make()
            let controller = DTSolveViewController(configure: configurator)
            tempViewControllerToPresent = controller
        case .mindset where UserDefault.mindsetExplanation.boolValue:
            let configurator = DTMindsetConfigurator.make()
            let controller = DTMindsetViewController(configure: configurator)
            tempViewControllerToPresent = controller
        case .recovery where UserDefault.recoveryExplanation.boolValue:
            let configurator = DTRecoveryConfigurator.make()
            let controller = DTRecoveryViewController(configure: configurator)
            tempViewControllerToPresent = controller
        default: break
        }

        if let viewControllerToPresent = tempViewControllerToPresent {
            viewController?.present(viewControllerToPresent, animated: true)
        }
        //showFeatureExplanation(coachSection)
    }

    func showFeatureExplanation(_ coachSection: CoachSection) {
        var tempType: FeatureExplainer.Kind?
        switch coachSection {
        case .tools: tempType = UserDefault.toolsExplanation.boolValue ? nil : .tools
        case .sprint: tempType = UserDefault.sprintExplanation.boolValue ? nil: .sprint
        case .event: tempType = UserDefault.prepareExplanation.boolValue ? nil : .prepare
        case .challenge: tempType = UserDefault.solveExplanation.boolValue ? nil : .solve
        case .mindset: tempType = UserDefault.mindsetExplanation.boolValue ? nil : .mindsetShifter
        case .recovery: tempType = UserDefault.recoveryExplanation.boolValue ? nil : .recovery
        default: return
        }
        guard let type = tempType,
            let controller = R.storyboard.featureExplainer().instantiateInitialViewController() as?
            FeatureExplainerViewController else { return }
        FeatureExplainerConfigurator.make(viewController: controller, type: type)
        viewController?.present(controller, animated: true, completion: nil)
    }
}

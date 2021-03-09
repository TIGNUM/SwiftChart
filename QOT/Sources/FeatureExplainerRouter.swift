//
//  FeatureExplainerRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.05.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class FeatureExplainerRouter {

    // MARK: - Properties
    private weak var viewController: FeatureExplainerViewController?

    // MARK: - Init
    init(viewController: FeatureExplainerViewController?) {
        self.viewController = viewController
    }
}

// MARK: - FeatureExplainerRouterInterface
extension FeatureExplainerRouter: FeatureExplainerRouterInterface {

    func didTapGetStarted(_ featureType: FeatureExplainer.Kind) {
        viewController?.dismiss(animated: true, completion: {
            switch featureType {
            case .sprint:
                let configurator = DTSprintConfigurator.make()
                let controller = DTSprintViewController(configure: configurator)
                self.viewController?.present(controller, animated: true)
            case .mindsetShifter:
                let configurator = DTMindsetConfigurator.make()
                let controller = DTMindsetViewController(configure: configurator)
                self.viewController?.present(controller, animated: true)
            case .prepare:
                if let launchURL = URLScheme.prepareEvent.launchURLWithParameterValue(String.empty) {
                    AppDelegate.current.launchHandler.process(url: launchURL)
                }
            case .tools:
                let toolsViewController = R.storyboard.tools.toolsViewControllerID()
                if let toolsViewController = toolsViewController {
                    ToolsConfigurator.make(viewController: toolsViewController)
                    self.viewController?.present(toolsViewController, animated: true, completion: nil)
                }
            case .solve:
                let configurator = DTSolveConfigurator.make()
                let controller = DTSolveViewController(configure: configurator)
                self.viewController?.present(controller, animated: true)
            case .recovery:
                let configurator = DTRecoveryConfigurator.make()
                let controller = DTRecoveryViewController(configure: configurator)
                self.viewController?.present(controller, animated: true)
            }
        })
    }
}

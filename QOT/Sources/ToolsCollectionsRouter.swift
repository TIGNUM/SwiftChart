//
//  ToolsCollectionsRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsCollectionsRouter {

    // MARK: - Properties
    private weak var viewController: ToolsCollectionsViewController?

    // MARK: - Init
    init(viewController: ToolsCollectionsViewController) {
        self.viewController = viewController
    }
}

// MARK: - CoachRouterInterface
extension ToolsCollectionsRouter: ToolsCollectionsRouterInterface {
    func presentToolsItems(selectedToolID: Int?) {
        viewController?.performSegue(withIdentifier: R.segue.toolsCollectionsViewController.collectionsItemsSegueIdentifier,
                                     sender: selectedToolID)
    }

    func presentDTRecovery() {
        let configurator = DTRecoveryConfigurator.make()
        let controller = DTRecoveryViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }

    func presentDTMindetShifter() {
        let configurator = DTMindsetConfigurator.make()
        let controller = DTMindsetViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }
}

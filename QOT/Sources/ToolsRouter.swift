//
//  ToolsRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsRouter {

    // MARK: - Properties

    private let viewController: ToolsViewController
    private let services: Services

    // MARK: - Init

    init(viewController: ToolsViewController, services: Services) {
        self.viewController = viewController
        self.services = services
    }
}

// MARK: - ToolsRouterInterface

extension ToolsRouter: ToolsRouterInterface {
    func presentToolsCollections(selectedToolID: Int?) {
        viewController.performSegue(withIdentifier: R.segue.toolsViewController.toolsCollectionsSegueIdentifier,
                                    sender: selectedToolID)
    }
}

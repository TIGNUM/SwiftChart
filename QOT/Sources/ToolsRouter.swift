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

    // MARK: - Init

    init(viewController: ToolsViewController) {
        self.viewController = viewController
    }
}

// MARK: - ToolsRouterInterface

extension ToolsRouter: ToolsRouterInterface {
    func presentToolsCollections(selectedToolID: Int?) {
        viewController.performSegue(withIdentifier: R.segue.toolsViewController.toolsCollectionsSegueIdentifier,
                                    sender: selectedToolID)
    }
}

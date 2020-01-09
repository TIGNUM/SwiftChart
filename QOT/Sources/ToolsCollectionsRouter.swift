//
//  ToolsCollectionsRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsCollectionsRouter: BaseRouter {

    // MARK: - Properties
    private weak var toolsViewController: ToolsCollectionsViewController?

    // MARK: - Init
    init(viewController: ToolsCollectionsViewController) {
        super.init(viewController: viewController)
        self.toolsViewController = viewController
    }
}

// MARK: - CoachRouterInterface
extension ToolsCollectionsRouter: ToolsCollectionsRouterInterface {
    func presentToolsItems(selectedToolID: Int?) {
        toolsViewController?.performSegue(withIdentifier: R.segue.toolsCollectionsViewController.collectionsItemsSegueIdentifier,
                                          sender: selectedToolID)
    }
}

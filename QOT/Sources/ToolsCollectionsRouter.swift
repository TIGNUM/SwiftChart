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

    private let viewController: ToolsCollectionsViewController

    // MARK: - Init

    init(viewController: ToolsCollectionsViewController) {
        self.viewController = viewController
    }
}

// MARK: - CoachRouterInterface

extension ToolsCollectionsRouter: ToolsCollectionsRouterInterface {

    func presentToolsItems(selectedToolID: Int?) {
        viewController.performSegue(withIdentifier: R.segue.toolsCollectionsViewController.collectionsItemsSegueIdentifier,
                                    sender: selectedToolID)
    }
}

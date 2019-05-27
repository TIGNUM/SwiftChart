//
//  ToolsCollectionsPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsCollectionsPresenter {

    // MARK: - Properties

    private weak var viewController: ToolsCollectionsViewControllerInterface?

    // MARK: - Init

    init(viewController: ToolsCollectionsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - CoachInterface

extension ToolsCollectionsPresenter: ToolsCollectionsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}

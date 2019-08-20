//
//  ToolsItemsPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsItemsPresenter {

    // MARK: - Properties

    private weak var viewController: ToolsItemsViewControllerInterface?

    // MARK: - Init

    init(viewController: ToolsItemsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - CoachInterface

extension ToolsItemsPresenter: ToolsItemsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func reload() {
        viewController?.reload()
    }
}

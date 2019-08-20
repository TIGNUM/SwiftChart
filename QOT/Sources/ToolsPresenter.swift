//
//  ToolsPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsPresenter {

    // MARK: - Properties

    private weak var viewController: ToolsViewControllerInterface?

    // MARK: - Init

    init(viewController: ToolsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - CoachInterface

extension ToolsPresenter: ToolsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func present(for toolSection: ToolModel) {
        viewController?.setup(for: toolSection)
    }

    func reload() {
        viewController?.reload()
    }
}

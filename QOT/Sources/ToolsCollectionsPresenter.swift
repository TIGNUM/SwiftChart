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
    private let selectedToolID: Int

    // MARK: - Init

    init(viewController: ToolsCollectionsViewControllerInterface, selectedToolID: Int) {
        self.viewController = viewController
        self.selectedToolID = selectedToolID
    }
}

// MARK: - CoachInterface

extension ToolsCollectionsPresenter: ToolsCollectionsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func reload() {
        viewController?.reload()
    }

    func selectedCategoryId() -> Int {
        return self.selectedToolID
    }
}

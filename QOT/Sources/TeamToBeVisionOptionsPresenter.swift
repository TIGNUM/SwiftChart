//
//  TeamToBeVisionOptionsPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamToBeVisionOptionsPresenter {

    // MARK: - Properties
    private weak var viewController: TeamToBeVisionOptionsViewControllerInterface?

    // MARK: - Init
    init(viewController: TeamToBeVisionOptionsViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - TeamToBeVisionOptionsInterface
extension TeamToBeVisionOptionsPresenter: TeamToBeVisionOptionsPresenterInterface {
    func setupView(type: TeamToBeVisionOptionsModel.Types, headerSubtitle: NSAttributedString) {
        viewController?.setupView(type: type, headerSubtitle: headerSubtitle)
    }

    func reload() {
        viewController?.reload()
    }
}

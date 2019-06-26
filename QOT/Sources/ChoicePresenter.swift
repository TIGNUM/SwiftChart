//
//  ChoicePresenter.swift
//  QOT
//
//  Created by karmic on 21.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ChoicePresenter {

    // MARK: - Properties

    private weak var viewController: ChoiceViewControllerInterface?

    // MARK: - Init

    init(viewController: ChoiceViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - ChoiceInterface

extension ChoicePresenter: ChoicePresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func reloadTableView() {
        viewController?.reloadTableView()
    }
}

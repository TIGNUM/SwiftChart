//
//  PrepareCheckListPresenter.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class PrepareCheckListPresenter {

    // MARK: - Properties

    private weak var viewController: PrepareCheckListViewControllerInterface?

    // MARK: - Init

    init(viewController: PrepareCheckListViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - PrepareCheckListInterface

extension PrepareCheckListPresenter: PrepareCheckListPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}

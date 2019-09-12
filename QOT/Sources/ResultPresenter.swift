//
//  ResultPresenter.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ResultPresenter {

    // MARK: - Properties
    private weak var viewController: ResultViewControllerInterface?

    // MARK: - Init
    init(viewController: ResultViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - ResultInterface
extension ResultPresenter: ResultPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}

//
//  ResultsPreparePresenter.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class ResultsPreparePresenter {

    // MARK: - Properties
    private weak var viewController: ResultsPrepareViewControllerInterface?

    // MARK: - Init
    init(viewController: ResultsPrepareViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - ResultsPrepareInterface
extension ResultsPreparePresenter: ResultsPreparePresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}

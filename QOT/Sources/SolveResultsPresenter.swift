//
//  SolveResultsPresenter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class SolveResultsPresenter {

    // MARK: - Properties
    private weak var viewController: SolveResultsViewControllerInterface?

    // MARK: - Init
    init(viewController: SolveResultsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SolveResultsInterface
extension SolveResultsPresenter: SolveResultsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func present(_ results: SolveResults) {
        viewController?.load(results)
    }
}

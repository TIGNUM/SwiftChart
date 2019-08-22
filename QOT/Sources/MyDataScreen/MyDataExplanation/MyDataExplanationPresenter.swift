//
//  MyDataExplanationPresenter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyDataExplanationPresenter {

    // MARK: - Properties
    private weak var viewController: MyDataExplanationViewControllerInterface?

    // MARK: - Init
    init(viewController: MyDataExplanationViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - MyDataExplanationInterface
extension MyDataExplanationPresenter: MyDataExplanationPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func present(for myDataExplanationSection: MyDataExplanationModel) {
        viewController?.setup(for: myDataExplanationSection)
    }
}

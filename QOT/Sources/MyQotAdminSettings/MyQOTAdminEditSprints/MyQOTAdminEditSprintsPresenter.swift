//
//  MyQOTAdminEditSprintsPresenter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQOTAdminEditSprintsPresenter {

    // MARK: - Properties
    private weak var viewController: MyQOTAdminEditSprintsViewControllerInterface?

    // MARK: - Init
    init(viewController: MyQOTAdminEditSprintsViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - MyQOTAdminEditSprintsInterface
extension MyQOTAdminEditSprintsPresenter: MyQOTAdminEditSprintsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}

//
//  MyQOTAdminEditSprintsDetailsPresenter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQOTAdminEditSprintsDetailsPresenter {

    // MARK: - Properties
    private weak var viewController: MyQOTAdminEditSprintsDetailsViewControllerInterface?

    // MARK: - Init
    init(viewController: MyQOTAdminEditSprintsDetailsViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - MyQOTAdminEditSprintsDetailsInterface
extension MyQOTAdminEditSprintsDetailsPresenter: MyQOTAdminEditSprintsDetailsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}

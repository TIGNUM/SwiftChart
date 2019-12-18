//
//  MyQotAdminSettingsListPresenter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminSettingsListPresenter {

    // MARK: - Properties
    private weak var viewController: MyQotAdminSettingsListViewControllerInterface?

    // MARK: - Init
    init(viewController: MyQotAdminSettingsListViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - MyQotAdminSettingsListInterface
extension MyQotAdminSettingsListPresenter: MyQotAdminSettingsListPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}

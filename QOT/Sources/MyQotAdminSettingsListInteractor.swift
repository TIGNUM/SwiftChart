//
//  MyQotAdminSettingsListInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminSettingsListInteractor {

    // MARK: - Properties
    private lazy var worker = MyQotAdminSettingsListWorker()
    private let presenter: MyQotAdminSettingsListPresenterInterface!

    // MARK: - Init
    init(presenter: MyQotAdminSettingsListPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQotAdminSettingsListInteractorInterface
extension MyQotAdminSettingsListInteractor: MyQotAdminSettingsListInteractorInterface {

}

//
//  MyQotAdminEnvironmentSettingsInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminEnvironmentSettingsInteractor {

    // MARK: - Properties
    private lazy var worker = MyQotAdminEnvironmentSettingsWorker()
    private let presenter: MyQotAdminEnvironmentSettingsPresenterInterface!

    // MARK: - Init
    init(presenter: MyQotAdminEnvironmentSettingsPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQotAdminEnvironmentSettingsInterface
extension MyQotAdminEnvironmentSettingsInteractor: MyQotAdminEnvironmentSettingsInteractorInterface {
}

//
//  MyQotAdminDCSixthQuestionSettingsInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminDCSixthQuestionSettingsInteractor {

    // MARK: - Properties
    private lazy var worker = MyQotAdminDCSixthQuestionSettingsWorker()
    private let presenter: MyQotAdminDCSixthQuestionSettingsPresenterInterface!

    // MARK: - Init
    init(presenter: MyQotAdminDCSixthQuestionSettingsPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQotAdminDCSixthQuestionSettingsInterface
extension MyQotAdminDCSixthQuestionSettingsInteractor: MyQotAdminDCSixthQuestionSettingsInteractorInterface {
}

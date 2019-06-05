//
//  MyQotAppSettingsInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAppSettingsInteractor {

    // MARK: - Properties

    private let worker: MyQotAppSettingsWorker
    private let presenter: MyQotAppSettingsPresenterInterface
    private let router: MyQotAppSettingsRouterInterface

    // MARK: - Init

    init(worker: MyQotAppSettingsWorker,
         presenter: MyQotAppSettingsPresenterInterface,
         router: MyQotAppSettingsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    func viewDidLoad() {
        presenter.present(worker.settings())
    }

    var appSettingsText: String {
        return worker.appSettingsText
    }
}

// MARK: - MyQotAppSettingsInteractorInterface

extension MyQotAppSettingsInteractor: MyQotAppSettingsInteractorInterface {
    func handleTap(setting: MyQotAppSettingsModel.Setting) {
        router.handleTap(setting: setting)
    }
}

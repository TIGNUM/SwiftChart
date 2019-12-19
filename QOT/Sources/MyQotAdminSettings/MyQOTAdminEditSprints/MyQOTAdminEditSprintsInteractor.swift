//
//  MyQOTAdminEditSprintsInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQOTAdminEditSprintsInteractor {

    // MARK: - Properties
    private lazy var worker = MyQOTAdminEditSprintsWorker()
    private let presenter: MyQOTAdminEditSprintsPresenterInterface!

    // MARK: - Init
    init(presenter: MyQOTAdminEditSprintsPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQOTAdminEditSprintsInteractorInterface
extension MyQOTAdminEditSprintsInteractor: MyQOTAdminEditSprintsInteractorInterface {
    func getHeaderTitle() -> String {
        return "EDIT SPRINTS"
    }

    func getDatasourceCount() -> Int {
        return worker.datasource.count
    }

    func getSprint(at index: Int) -> QDMSprint {
        return worker.datasource[index]
    }

    func getSprints(completion: @escaping () -> Void) {
        worker.getSprints(completion: completion)
    }
}

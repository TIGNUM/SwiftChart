//
//  MyDataScreenInteractor.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit

final class MyDataScreenInteractor {

    // MARK: - Properties
    private let worker: MyDataScreenWorker
    private let presenter: MyDataScreenPresenterInterface
    private let router: MyDataScreenRouterInterface

    // MARK: - Init
    init(worker: MyDataScreenWorker, presenter: MyDataScreenPresenterInterface, router: MyDataScreenRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.present(for: worker.myDataSections())
        presenter.setupView()
    }
}

// MARK: - MyDataScreenInteractorInterface
extension MyDataScreenInteractor: MyDataScreenInteractorInterface {
    func presentMyDataExplanation() {
        router.presentMyDataExplanation()
    }

    func presentMyDataSelection() {
        router.presentMyDataSelection()
    }

    func myDataSelectionSections() -> MyDataSelectionModel {
        return worker.myDataSelectionSections()
    }

    func initialDataSelectionSections() -> MyDataSelectionModel {
        return worker.initialDataSelectionSections
    }

    func getDailyResults(around date: Date,
                         withMonthsBefore: Int,
                         monthsAfter: Int,
                         _ completion: @escaping([Date: MyDataDailyCheckInModel]?, Error?) -> Void) {
        worker.getDailyResults(around: date,
                               withMonthsBefore: withMonthsBefore,
                               monthsAfter: monthsAfter,
                               completion)
    }
}

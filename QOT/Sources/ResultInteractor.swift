//
//  ResultInteractor.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ResultInteractor {

    // MARK: - Properties
    private let worker: ResultWorker
    private let presenter: ResultPresenterInterface

    // MARK: - Init
    init(worker: ResultWorker, presenter: ResultPresenterInterface) {
        self.worker = worker
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - ResultInteractorInterface
extension ResultInteractor: ResultInteractorInterface {

}

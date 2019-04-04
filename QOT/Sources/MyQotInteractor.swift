//
//  MyQotInteractor.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotInteractor {

    // MARK: - Properties

    private let worker: MyQotWorker
    private let presenter: MyQotPresenterInterface
    private let router: MyQotRouterInterface

    // MARK: - Init

    init(worker: MyQotWorker,
        presenter: MyQotPresenterInterface,
        router: MyQotRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQotInteractorInterface

extension MyQotInteractor: MyQotInteractorInterface {

}

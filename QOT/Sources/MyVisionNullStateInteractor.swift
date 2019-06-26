//
//  MyToBeVisionNullStateInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 19.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyVisionNullStateInteractor {
    let presenter: MyVisionNullStatePresenterInterface
    let router: MyVisionNullStateRouter
    let worker: MyVisionNullStateWorker

    init(presenter: MyVisionNullStatePresenterInterface,
         router: MyVisionNullStateRouter,
         worker: MyVisionNullStateWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
    }
}

extension  MyVisionNullStateInteractor: MyVisionNullStateInteractorInterface {

    var headlinePlaceholder: String? {
        return worker.headlinePlaceholder
    }

    var messagePlaceholder: String? {
        return worker.messagePlaceholder
    }

    func openToBeVisionGenerator() {

    }
    func openToBeVisionEditController() {

    }

    func viewDidLoad() {
        presenter.setupView()
    }
}

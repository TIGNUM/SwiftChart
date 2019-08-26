//
//  WalkthroughSwipeInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughSwipeInteractor {

    // MARK: - Properties

    private let worker: WalkthroughSwipeWorker
    private let presenter: WalkthroughSwipePresenterInterface
    private let router: WalkthroughSwipeRouterInterface

    // MARK: - Init

    init(worker: WalkthroughSwipeWorker,
        presenter: WalkthroughSwipePresenterInterface,
        router: WalkthroughSwipeRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }

    var text: String {
        return worker.text
    }
}

// MARK: - WalkthroughSwipeInteractorInterface

extension WalkthroughSwipeInteractor: WalkthroughSwipeInteractorInterface {

}

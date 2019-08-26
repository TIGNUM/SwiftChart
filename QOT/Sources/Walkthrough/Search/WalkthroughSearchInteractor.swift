//
//  WalkthroughSearchInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughSearchInteractor {

    // MARK: - Properties

    private let worker: WalkthroughSearchWorker
    private let presenter: WalkthroughSearchPresenterInterface
    private let router: WalkthroughSearchRouterInterface

    // MARK: - Init

    init(worker: WalkthroughSearchWorker,
        presenter: WalkthroughSearchPresenterInterface,
        router: WalkthroughSearchRouterInterface) {
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

// MARK: - WalkthroughSearchInteractorInterface

extension WalkthroughSearchInteractor: WalkthroughSearchInteractorInterface {

}

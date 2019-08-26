//
//  WalkthroughCoachInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughCoachInteractor {

    // MARK: - Properties

    private let worker: WalkthroughCoachWorker
    private let presenter: WalkthroughCoachPresenterInterface
    private let router: WalkthroughCoachRouterInterface

    // MARK: - Init

    init(worker: WalkthroughCoachWorker,
        presenter: WalkthroughCoachPresenterInterface,
        router: WalkthroughCoachRouterInterface) {
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

// MARK: - WalkthroughCoachInteractorInterface

extension WalkthroughCoachInteractor: WalkthroughCoachInteractorInterface {

}

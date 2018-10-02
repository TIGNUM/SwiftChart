//
//  SupportFAQInteractor.swift
//  QOT
//
//  Created by karmic on 01.10.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SupportFAQInteractor {

    // MARK: - Properties

    private let worker: SupportFAQWorker
    private let presenter: SupportFAQPresenterInterface

    // MARK: - Init

    init(worker: SupportFAQWorker, presenter: SupportFAQPresenterInterface) {
        self.worker = worker
        self.presenter = presenter
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - SupportFAQInteractorInterface

extension SupportFAQInteractor: SupportFAQInteractorInterface {

    var itemCount: Int {
        return worker.itemCount
    }

    func item(at indexPath: IndexPath) -> ContentCollection {
        return worker.item(at: indexPath)
    }

    func title(at indexPath: IndexPath) -> NSAttributedString? {
        return worker.title(at: indexPath)
    }
}

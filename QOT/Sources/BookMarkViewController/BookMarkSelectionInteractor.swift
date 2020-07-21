//
//  BookMarkSelectionInteractor.swift
//  QOT
//
//  Created by Sanggeon Park on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class BookMarkSelectionInteractor {

    // MARK: - Properties

    private let worker: BookMarkSelectionWorker
    private let presenter: BookMarkSelectionPresenterInterface
    private let router: BookMarkSelectionRouterInterface

    private let existingBookMarks: [QDMUserStorage]

    // MARK: - Init

    init(storages: [QDMUserStorage],
        worker: BookMarkSelectionWorker,
        presenter: BookMarkSelectionPresenterInterface,
        router: BookMarkSelectionRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.existingBookMarks = storages.filter({ $0.userStorageType == .BOOKMARK })
    }

    // MARK: - Interactor

    func viewDidLoad() {
        worker.viewModels(from: existingBookMarks) { (viewModels) in
            // UPDATE LIST
        }
    }
}

// MARK: - BookMarkSelectionInteractorInterface

extension BookMarkSelectionInteractor: BookMarkSelectionInteractorInterface {

}

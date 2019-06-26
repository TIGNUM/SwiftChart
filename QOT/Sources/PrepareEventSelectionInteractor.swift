//
//  PrepareEventSelectionInteractor.swift
//  QOT
//
//  Created by karmic on 27.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class PrepareEventSelectionInteractor {

    // MARK: - Properties

    private let worker: PrepareEventSelectionWorker
    private let presenter: PrepareEventSelectionPresenterInterface
    private let router: PrepareEventSelectionRouterInterface

    // MARK: - Init

    init(worker: PrepareEventSelectionWorker,
        presenter: PrepareEventSelectionPresenterInterface,
        router: PrepareEventSelectionRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {}
}

// MARK: - PrepareEventSelectionInteractorInterface

extension PrepareEventSelectionInteractor: PrepareEventSelectionInteractorInterface {
    var rowCount: Int {
        return worker.rowCount
    }

    func event(at indexPath: IndexPath) -> QDMUserCalendarEvent? {
        return worker.event(at: indexPath)
    }

    func dateString(for event: QDMUserCalendarEvent?) -> String? {
        return worker.dateString(for: event)
    }

    func didSelect(_ event: QDMUserCalendarEvent) {
        guard let answer = worker.selectedAnswer else { return }
        router.didSelectCalendarEvent(event, selectedAnswer: answer)
    }
}

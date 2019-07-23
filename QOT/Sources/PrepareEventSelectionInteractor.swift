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

    func event(at indexPath: IndexPath) -> PrepareEvent? {
        return worker.event(at: indexPath)
    }

    func dateString(for date: Date?) -> String? {
        return worker.dateString(for: date)
    }

    func didSelect(_ event: PrepareEvent) {
        if
            let answer = worker.selectedAnswer,
            let userCalendarEvent = event.userCalendarEvent {
                router.didSelectCalendarEvent(userCalendarEvent, selectedAnswer: answer)
        }

        if let userPreparation = event.userPreparation {
            router.didSelectPreparation(userPreparation)
        }
    }
}

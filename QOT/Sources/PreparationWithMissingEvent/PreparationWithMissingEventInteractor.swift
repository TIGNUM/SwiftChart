//
//  PreparationWithMissingEventInteractor.swift
//  QOT
//
//  Created by Sanggeon Park on 18.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class PreparationWithMissingEventInteractor {

    // MARK: - Properties

    private let worker: PreparationWithMissingEventWorker
    private let presenter: PreparationWithMissingEventPresenterInterface
    private let router: PreparationWithMissingEventRouterInterface

    private var events = [QDMUserCalendarEvent]()
    private var preparation: QDMUserPreparation?

    // MARK: - Init

    init(worker: PreparationWithMissingEventWorker,
        presenter: PreparationWithMissingEventPresenterInterface,
        router: PreparationWithMissingEventRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillResignActive(_:)),
                                               name: .UIApplicationWillResignActive, object: nil)
    }

    // MARK: - Interactor

    func viewDidLoad() {
        next()
    }

    func next() {
        if let next = worker.nextPreparation() {
            preparation = next
            presenter.update(title: worker.titleFor(next),
                             text: worker.textFor(next),
                             removeButtonTitle: worker.removeButtonTitle(),
                             keepButtonTitle: worker.keepButtonTitle())
            worker.events { (events) in
                self.events = events
                self.presenter.reloadEvents()
            }
        } else {
            router.dismiss()
        }
    }

    @objc func applicationWillResignActive(_ notification: Notification) {
        router.dismiss()
    }
}

// MARK: - PreparationWithMissingEventInteractorInterface

extension PreparationWithMissingEventInteractor: PreparationWithMissingEventInteractorInterface {

    func preparationRemoteId() -> Int? {
        return preparation?.remoteID
    }

    func preparationTitle() -> String {
        return preparation?.eventTitle ?? ""
    }

    func keepPreparation() {
        worker.keepPreparation(preparation: preparation!)
        next()
    }

    func deletePreparation() {
        worker.deletePreparation(preparation: preparation!)
        next()
    }

    func updatePreparation(with newEvent: QDMUserCalendarEvent) {
        worker.updatePreparation(preparation: preparation!, with: newEvent)
        next()
    }

    func eventAt(_ index: Int) -> QDMUserCalendarEvent {
        return events[index]
    }

    func eventCount() -> Int {
        return events.count
    }
}

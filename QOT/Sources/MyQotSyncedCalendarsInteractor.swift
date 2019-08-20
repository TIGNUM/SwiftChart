//
//  MyQotSyncedCalendarsInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class SyncedCalendarsInteractor {

    // MARK: - Properties
    private let worker: SyncedCalendarsWorker
    private let presenter: MyQotSyncedCalendarsPresenterInterface

    // MARK: - Init
    init(worker: SyncedCalendarsWorker, presenter: MyQotSyncedCalendarsPresenterInterface) {
        self.worker = worker
        self.presenter = presenter
    }
}

// MARK: - MyQotSyncedCalendarsInteractorInterface
extension SyncedCalendarsInteractor: MyQotSyncedCalendarsInteractorInterface {
    func viewDidLoad() {
        worker.headerTitle { [unowned self] (header) in
            self.presenter.setupView(with: header)
        }
    }

    var viewModel: SettingsCalendarListViewModel {
        return worker.viewModelObj
    }
}

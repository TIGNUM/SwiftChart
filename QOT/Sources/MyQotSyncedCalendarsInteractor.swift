//
//  MyQotSyncedCalendarsInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSyncedCalendarsInteractor {
    // MARK: - Properties
    
    private let worker: MyQotSyncedCalendarsWorker
    private let presenter: MyQotSyncedCalendarsPresenterInterface
    
    // MARK: - Init
    
    init(worker: MyQotSyncedCalendarsWorker, presenter: MyQotSyncedCalendarsPresenterInterface) {
        self.worker = worker
        self.presenter = presenter
    }
}

extension MyQotSyncedCalendarsInteractor: MyQotSyncedCalendarsInteractorInterface {

    func viewDidLoad() {
        presenter.setupView(with: worker.headerTitle)
    }
    
    var viewModel: SettingsCalendarListViewModel {
        return worker.viewModelObj
    }
}

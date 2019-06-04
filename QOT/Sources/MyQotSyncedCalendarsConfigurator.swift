//
//  MyQotSyncedCalendarsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSyncedCalendarsConfigurator: AppStateAccess {
    static func configure(viewController: MyQotSyncedCalendarsViewController) {
        let worker = MyQotSyncedCalendarsWorker(services: appState.services, viewModel: SettingsCalendarListViewModel(services: appState.services))
        let presenter = MyQotSyncedCalendarsPresenter(viewController: viewController)
        let interactor = MyQotSyncedCalendarsInteractor(worker: worker, presenter: presenter)
        viewController.interactor = interactor
    }
}

//
//  SyncedCalendarsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class SyncedCalendarsConfigurator {
    static func configure(viewController: SyncedCalendarsViewController,
                          isInitialCalendarSelection: Bool = false,
                          delegate: SyncedCalendarsDelegate? = nil) {
        let presenter = SyncedCalendarsPresenter(viewController)
        let router = SyncedCalendarsRouter(viewController)
        let interactor = SyncedCalendarsInteractor(presenter,
                                                   router: router,
                                                   isInitialCalendarSelection: isInitialCalendarSelection,
                                                   delegate: delegate)
        viewController.interactor = interactor
    }
}

//
//  SyncedCalendarsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class SyncedCalendarsConfigurator {
    static func configure(viewController: SyncedCalendarsViewController) {
        let presenter = SyncedCalendarsPresenter(viewController)
        let interactor = SyncedCalendarsInteractor(presenter)
        viewController.interactor = interactor
    }
}

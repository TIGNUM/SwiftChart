//
//  SyncedCalendarsInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol SyncedCalendarsViewControllerInterface: class {
    func setupView(_ viewModel: SyncedCalendarsViewModel?)
    func updateViewModel(_ viewModel: SyncedCalendarsViewModel?)
}

protocol SyncedCalendarsPresenterInterface {
    func setupView(_ viewTitle: String, _ qdmCalendarSettings: [QDMUserCalendarSetting])
    func updateSettings( _ qdmCalendarSetting: QDMUserCalendarSetting?)
}

protocol SyncedCalendarsInteractorInterface: Interactor {
    func updateSyncStatus(enabled: Bool, identifier: String)
}

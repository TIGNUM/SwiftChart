//
//  SyncedCalendarsInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol SyncedCalendarsDelegate: class {
    func didFinishSyncingCalendars(hasEvents: Bool)
}

protocol SyncedCalendarsViewControllerInterface: class {
    func setupView(_ viewModel: SyncedCalendarsViewModel?)
    func updateViewModel(_ viewModel: SyncedCalendarsViewModel?)
}

protocol SyncedCalendarsPresenterInterface {
    func setupView(_ viewTitle: String, _ qdmCalendarSettings: [QDMUserCalendarSetting])
    func updateSettings( _ qdmCalendarSetting: QDMUserCalendarSetting?)
}

protocol SyncedCalendarsInteractorInterface: Interactor {
    var skipButtonTitle: String { get }
    var saveButtonTitle: String { get }
    var isInitialCalendarSelection: Bool { get }
    func updateSyncStatus(enabled: Bool, identifier: String)
    func didTapSkip()
    func didTapSave()
}

protocol SyncedCalendarsRouterInterface {
    func dismiss(_ completion: (() -> Void)?)
}

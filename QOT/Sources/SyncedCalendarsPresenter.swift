//
//  SyncedCalendarsPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class SyncedCalendarsPresenter {

    // MARK: - Properties
    private weak var viewController: SyncedCalendarsViewControllerInterface?
    private var viewModel: SyncedCalendarsViewModel?

    // MARK: - Init
    init(_ viewController: SyncedCalendarsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SyncedCalendarsPresenterInterface
extension SyncedCalendarsPresenter: SyncedCalendarsPresenterInterface {
    func setupView(_ viewTitle: String, _ qdmCalendarSettings: [QDMUserCalendarSetting]) {
        createViewModel(viewTitle, qdmCalendarSettings)
    }

    func updateSettings( _ qdmCalendarSetting: QDMUserCalendarSetting?) {
        viewModel?.updateSyncValue(qdmCalendarSetting?.syncEnabled, calendarId: qdmCalendarSetting?.calendarId)
        viewController?.updateViewModel(viewModel)
    }
}

// MARK: - Private
private extension SyncedCalendarsPresenter {
    func createViewModel(_ viewTitle: String, _ qdmCalendarSettings: [QDMUserCalendarSetting]) {
        let localSettings = qdmCalendarSettings.filter { (setting) -> Bool in
            return EKEventStore.shared.localIds.contains(obj: setting.calendarId ?? "")
        }
        let otherSettings = qdmCalendarSettings.filter { (setting) -> Bool in
            let exist = EKEventStore.shared.localIds.contains(obj: setting.calendarId ?? "")
            return exist == false && setting.syncEnabled == true
        }

        let localItems = localSettings.compactMap { createModel($0, switchIsHidden: false) }
        let otherItems = otherSettings.compactMap { createModel($0, switchIsHidden: true) }
        var sections = [SyncedCalendarsViewModel.Section.onDevice: localItems]
        if !otherSettings.isEmpty {
            sections[SyncedCalendarsViewModel.Section.notOnDevice] = otherItems
        }
        viewModel = SyncedCalendarsViewModel(viewTitle: viewTitle, sections: sections)
        viewController?.setupView(viewModel)
    }

    func createModel(_ setting: QDMUserCalendarSetting, switchIsHidden: Bool) -> SyncedCalendarsViewModel.Row {
        return SyncedCalendarsViewModel.Row(title: setting.title,
                                            identifier: setting.calendarId,
                                            source: setting.source,
                                            syncEnabled: setting.syncEnabled,
                                            switchIsHidden: switchIsHidden)
    }
}

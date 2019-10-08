//
//  SyncedCalendarsPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal
import EventKit

final class SyncedCalendarsPresenter {

    // MARK: - Properties
    private weak var viewController: SyncedCalendarsViewControllerInterface?
    private var viewModel: SyncedCalendarsViewModel?
    private lazy var calendars: [EKCalendar] = {
        return EKEventStore.shared.calendars(for: .event)
    }()

    // MARK: - Init
    init(_ viewController: SyncedCalendarsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SyncedCalendarsPresenterInterface
extension SyncedCalendarsPresenter: SyncedCalendarsPresenterInterface {
    func setupView(_ viewTitle: String, _ viewSubtitle: String, _ qdmCalendarSettings: [QDMUserCalendarSetting]) {
        createViewModel(viewTitle, viewSubtitle, qdmCalendarSettings)
    }

    func updateSettings( _ qdmCalendarSetting: QDMUserCalendarSetting?) {
        viewModel?.updateSyncValue(qdmCalendarSetting?.syncEnabled, calendarId: qdmCalendarSetting?.calendarId)
        viewController?.updateViewModel(viewModel)
    }
}

// MARK: - Private
private extension SyncedCalendarsPresenter {
    func createViewModel(_ viewTitle: String, _ viewSubtitle: String, _ qdmCalendarSettings: [QDMUserCalendarSetting]) {
        let localSettings = qdmCalendarSettings.filter { (setting) -> Bool in
            return EKEventStore.shared.localIds.contains(obj: setting.calendarId ?? "")
        }

        let otherSettings = qdmCalendarSettings.filter { (setting) -> Bool in
            let exist = EKEventStore.shared.localIds.contains(obj: setting.calendarId ?? "")
            return exist == false && setting.syncEnabled == true
        }

        let localItems = localSettings.compactMap { createModel($0, switchIsHidden: false) }.sorted { (lhs, rhs) -> Bool in
            return lhs.isSubscribed == false && rhs.isSubscribed == true
        }

        let otherItems = otherSettings.compactMap { createModel($0, switchIsHidden: true) }
        var sections = [SyncedCalendarsViewModel.Section.onDevice: localItems]
        if !otherSettings.isEmpty {
            sections[SyncedCalendarsViewModel.Section.notOnDevice] = otherItems
        }
        let footerHeight: CGFloat = localItems.filter { $0.isSubscribed == true }.isEmpty ? 0 : 80
        viewModel = SyncedCalendarsViewModel(viewTitle: viewTitle,
                                             viewSubtitle: viewSubtitle,
                                             footerHeight: footerHeight,
                                             sections: sections)
        viewController?.setupView(viewModel)
    }

    func createModel(_ setting: QDMUserCalendarSetting, switchIsHidden: Bool) -> SyncedCalendarsViewModel.Row {
        let calendar = calendars.filter { $0.toggleIdentifier == setting.calendarId }.first
        return SyncedCalendarsViewModel.Row(title: setting.title?.uppercased(),
                                            identifier: setting.calendarId,
                                            source: setting.source,
                                            syncEnabled: setting.syncEnabled,
                                            isSubscribed: calendar?.isSubscribed,
                                            switchIsHidden: switchIsHidden)
    }
}

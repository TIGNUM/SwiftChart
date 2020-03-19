//
//  SyncedCalendarsInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class SyncedCalendarsInteractor {

    // MARK: - Properties
    private lazy var workerCalendar: WorkerCalendar? = WorkerCalendar()
    private lazy var worker = SyncedCalendarsWorker()
    private let presenter: SyncedCalendarsPresenterInterface
    private let router: SyncedCalendarsRouterInterface
    private var calendarSettings: [QDMUserCalendarSetting] = []
    private weak var delegate: SyncedCalendarsDelegate?
    let isInitialCalendarSelection: Bool

    // MARK: - Init
    init(_ presenter: SyncedCalendarsPresenterInterface,
         router: SyncedCalendarsRouterInterface,
         isInitialCalendarSelection: Bool,
         delegate: SyncedCalendarsDelegate?) {
        self.presenter = presenter
        self.router = router
        self.isInitialCalendarSelection = isInitialCalendarSelection
        self.delegate = delegate
    }

    // MARK: - Life Cycle
    func viewDidLoad() {
        getData()
    }

    // MARK: - Texts
    var skipButtonTitle: String {
        return worker.skipButton
    }

    var saveButtonTitle: String {
        return worker.saveButton
    }
}

// MARK: - Private
private extension SyncedCalendarsInteractor {
    func getData() {
        let viewTitle = worker.viewTitle
        let viewSubtitle = worker.viewSubtitle
        workerCalendar?.getCalendarSettings { [weak self] (calendarSettings) in
            self?.calendarSettings = calendarSettings
            self?.presenter.setupView(viewTitle, viewSubtitle, calendarSettings)
        }
    }

    func updateCalendarSetting(_ setting: QDMUserCalendarSetting?) {
        if let index = calendarSettings.index(where: { $0.calendarId == setting?.calendarId }) {
            var cached = calendarSettings[index]
            cached.syncEnabled = setting?.syncEnabled ?? false
            calendarSettings[index] = cached
        }
        presenter.updateSettings(setting)
    }
}

// MARK: - SyncedCalendarsInteractorInterface
extension SyncedCalendarsInteractor: SyncedCalendarsInteractorInterface {
    func updateSyncStatus(enabled: Bool, identifier: String) {
        var calendarSetting = calendarSettings.filter { $0.calendarId == identifier }.first
        calendarSetting?.syncEnabled = enabled
        workerCalendar?.updateCalendarSetting(calendarSetting) { [weak self] (setting) in
            self?.updateCalendarSetting(setting)
        }
    }

    func didTapSkip() {
        router.dismiss(completion: nil)
        // Disable all calendars
        let enabledSettings = calendarSettings.filter { $0.syncEnabled == true }
        let updatedSettings = enabledSettings.compactMap { (setting) -> QDMUserCalendarSetting in
            var tmpSetting = setting
            tmpSetting.syncEnabled = false
            return tmpSetting
        }
        delegate?.didFinishSyncingCalendars(hasSyncedCalendars: !updatedSettings.isEmpty, qdmEvents: [])
        workerCalendar?.updateCalendarSettings(updatedSettings)
    }

    func didTapSave() {
        let enabledSettings = calendarSettings.filter { $0.syncEnabled == true }
        workerCalendar?.getCalendarEvents { [weak self] (events) in
            self?.router.dismiss {
                self?.delegate?.didFinishSyncingCalendars(hasSyncedCalendars: !enabledSettings.isEmpty,
                                                          qdmEvents: events)
            }
        }
    }
}

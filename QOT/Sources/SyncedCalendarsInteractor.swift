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
        // Disable all calendars
        calendarSettings.forEach {
            var setting = $0
            setting.syncEnabled = false
            workerCalendar?.updateCalendarSetting(setting) { _ in }
        }
        self.router.dismiss {
            self.delegate?.didFinishSyncingCalendars(qdmEvents: [])
        }
    }

    func didTapSave() {
        workerCalendar?.getCalendarEvents { [weak self] (events) in
            self?.router.dismiss {
                self?.delegate?.didFinishSyncingCalendars(qdmEvents: events)
            }
        }
    }
}

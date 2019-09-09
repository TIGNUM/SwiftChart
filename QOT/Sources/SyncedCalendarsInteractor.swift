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
    private lazy var worker = SyncedCalendarsWorker()
    private lazy var dispatchGroup = DispatchGroup()
    private let presenter: SyncedCalendarsPresenterInterface
    private var calendarSettings: [QDMUserCalendarSetting] = []
    private var viewTitle = ""

    // MARK: - Init
    init(_ presenter: SyncedCalendarsPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Life Cycle
    func viewDidLoad() {
        getData()
    }
}

// MARK: - Get data
private extension SyncedCalendarsInteractor {
    func getData() {
        getViewTitle()
        getCalendarData()
        dispatchGroup.notify(queue: .main) { [unowned self] in
            self.presenter.setupView(self.viewTitle, self.calendarSettings)
        }
    }

    func getViewTitle() {
         self.viewTitle = worker.viewTitle
    }

    func getCalendarData() {
        dispatchGroup.enter()
        worker.getCalendarSettings { [unowned self] (calendarSettings) in
            self.calendarSettings = calendarSettings
            self.dispatchGroup.leave()
        }
    }
}

// MARK: - Write data
private extension SyncedCalendarsInteractor {
    func updateCalendarSetting(_ calendarSetting: QDMUserCalendarSetting?) {
        guard let setting = calendarSetting else { return }
        qot_dal.CalendarService.main.updateCalendarSetting(setting) { [weak self] (calendarSetting, error) in
            if let error = error {
                qot_dal.log("Error updateCalendarSetting: \(error.localizedDescription)", level: .error)
            }
            self?.presenter.updateSettings(calendarSetting)
        }
    }
}

// MARK: - SyncedCalendarsInteractorInterface
extension SyncedCalendarsInteractor: SyncedCalendarsInteractorInterface {
    func updateSyncStatus(enabled: Bool, identifier: String) {
        var calendarSetting = calendarSettings.filter { $0.calendarId == identifier }.first
        calendarSetting?.syncEnabled = enabled
        updateCalendarSetting(calendarSetting)
    }
}

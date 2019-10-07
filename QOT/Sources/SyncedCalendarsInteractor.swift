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
    private lazy var skipDispatchGroup = DispatchGroup()
    private let presenter: SyncedCalendarsPresenterInterface
    private let router: SyncedCalendarsRouterInterface
    private var calendarSettings: [QDMUserCalendarSetting] = []
    private var viewTitle = ""
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

// MARK: - Get data

private extension SyncedCalendarsInteractor {

    func getData() {
        getViewTitle()
        getCalendarData()
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.presenter.setupView(strongSelf.viewTitle, strongSelf.calendarSettings)
        }
    }

    func getViewTitle() {
         self.viewTitle = worker.viewTitle
    }

    func getCalendarData() {
        dispatchGroup.enter()
        worker.getCalendarSettings { [weak self] (calendarSettings) in
            guard let strongSelf = self else { return }
            strongSelf.calendarSettings = calendarSettings
            strongSelf.dispatchGroup.leave()
        }
    }
}

// MARK: - SyncedCalendarsInteractorInterface

extension SyncedCalendarsInteractor: SyncedCalendarsInteractorInterface {

    func updateSyncStatus(enabled: Bool, identifier: String) {
        var calendarSetting = calendarSettings.filter { $0.calendarId == identifier }.first
        calendarSetting?.syncEnabled = enabled
        worker.updateCalendarSetting(calendarSetting) { [weak self] (setting) in
            self?.updateCalendarSetting(setting)
        }
    }

    func didTapSkip() {
        // Disable all calendars
        calendarSettings.forEach {
            skipDispatchGroup.enter()
            var setting = $0
            setting.syncEnabled = false
            worker.updateCalendarSetting(setting, { (_) in
                self.skipDispatchGroup.leave()
            })
        }
        // Notify success
        skipDispatchGroup.notify(queue: .main) {
            self.router.dismiss({
                self.delegate?.didFinishSyncingCalendars(hasEvents: false)
            })
        }
    }

    func didTapSave() {
        worker.getCalendarEvents { (events) in
            self.router.dismiss({
                self.delegate?.didFinishSyncingCalendars(hasEvents: !events.isEmpty)
            })
        }
    }
}

// MARK: - Private methods

extension SyncedCalendarsInteractor {
    func updateCalendarSetting(_ setting: QDMUserCalendarSetting?) {
        // Update own cache
        if let index = calendarSettings.index(where: { $0.calendarId == setting?.calendarId }) {
            var cached = calendarSettings[index]
            cached.syncEnabled = setting?.syncEnabled ?? false
            calendarSettings[index] = cached
        }
        // Update view model
        presenter.updateSettings(setting)
    }
}

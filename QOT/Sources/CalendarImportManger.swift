//
//  CalendarSyncManager.swift
//  QOT
//
//  Created by Sam Wyndham on 16/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import EventKit
import RealmSwift

/// The delegate of `CalendarImportManger`.
protocol CalendarImportMangerDelegate: class {
    /// Notifies `self` that the current `EKAuthorizationStatus` is not sufficient.
    func eventStoreAuthorizationRequired(for mangager: CalendarImportManger, currentStatus: EKAuthorizationStatus)
    /// Notifies `self` that a calendar import failed with `error`.
    func calendarImportDidFail(error: Error)
}

/// Manages the one-way sync of `EKEvent`'s into `Realm`, both manually by calling `importEvents()`, and automatically
/// when the event `EKEventStoreChanged` notifications are posted.
final class CalendarImportManger {

    private let realmProvider: RealmProvider
    private let queue = DispatchQueue(label: "com.tignum.qot.calendarSync", qos: .background)
    private let notificationHandler: NotificationHandler
    private let store = EKEventStore.shared
    private let syncSettingsManager: CalendarSyncSettingsManager

    var predicate: () -> (start: Date, end: Date)
    var isImportingEvents = false
    weak var delegate: CalendarImportMangerDelegate?

    init(realm: RealmProvider, predicate: @escaping () -> (start: Date, end: Date)) {
        self.realmProvider = realm
        self.predicate = predicate
        self.notificationHandler = NotificationHandler(name: .EKEventStoreChanged, object: store)
        self.syncSettingsManager = CalendarSyncSettingsManager(realmProvider: realmProvider)

        self.notificationHandler.handler = { [unowned self] (notificationCenter) in
            self.importEvents()
        }
    }

    func importEvents() {
        do {
            try syncSettingsManager.updateSyncSettingsWithEventStore()
        } catch {
            assertionFailure("Failed to update calendar sync settings: \(error)")
        }

        let status = EKEventStore.authorizationStatus(for: .event)

        if status == .authorized {
            if isImportingEvents {
                return
            }

            isImportingEvents = true
            let (start, end) = predicate()
            sync(start: start, end: end) { [weak self] (result: CalendarImportResult) in
                switch result {
                case .success:
                    break // No operation needed
                case .failure(let error):
                    self?.delegate?.calendarImportDidFail(error: error)
                }
                self?.isImportingEvents = false
            }
        } else {
            delegate?.eventStoreAuthorizationRequired(for: self, currentStatus: status)
        }
    }

    private func sync(start: Date, end: Date, completion: @escaping (CalendarImportResult) -> Void) {
        queue.async { [store, realmProvider] in
            let result: CalendarImportResult
            do {
                let realm = try realmProvider.realm()
                let task = CalendarImportTask(startDate: start, endDate: end, realm: realm, store: store)
                result = task.sync(calendars: self.syncSettingsManager.syncEnabledCalendars)
            } catch let error {
                result = .failure(error)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

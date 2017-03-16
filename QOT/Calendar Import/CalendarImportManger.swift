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
    private let store: EKEventStore
    private let realm: () throws -> Realm
    private let queue = DispatchQueue(label: "com.tignum.qot.calendarSync", qos: .background)
    private let notificationHandler: NotificationHandler

    /// The predicate for for which `EKEvents` to fetch from `EKEventStore`.
    var predicate: (EKEventStore) -> NSPredicate
    /// The delegate of `self`.
    weak var delegate: CalendarImportMangerDelegate?
    
    /// Creates an instance that imports `EKEvent`s from `store` matching `predicate` into `realm`.
    init(realm: @escaping () throws -> Realm, predicate: @escaping (EKEventStore) -> NSPredicate, store: EKEventStore = EKEventStore(), notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.store = store
        self.realm = realm
        self.predicate = predicate
        self.notificationHandler = NotificationHandler(name: .EKEventStoreChanged, object: store)
        
        self.notificationHandler.handler = { [unowned self] (notificationCenter) in
            self.importEvents()
        }
    }
    
    /// Import `EKEvent`s matching `predicate`.
    func importEvents() {
        let status = EKEventStore.authorizationStatus(for: .event)
        
        if status == .authorized {
            sync(predicate: predicate(store)) { [weak self] (result) in
                switch result {
                case .success:
                    break // No operation needed
                case .failure(let error):
                    self?.delegate?.calendarImportDidFail(error: error)
                }
            }
        } else {
            delegate?.eventStoreAuthorizationRequired(for: self, currentStatus: status)
        }
    }
    
    private func sync(predicate: NSPredicate, completion: @escaping (CalendarImportResult) -> Void) {
        queue.async { [store, realm] in
            let result: CalendarImportResult
            do {
                let events = store.events(matching: predicate)
                let realm = try realm()
                let task = CalendarImportTask()
                result = task.sync(events: events, realm: realm, store: store)
            } catch let error {
                result = .failure(error)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    @objc func calendarDidChange() {
        importEvents()
    }
}

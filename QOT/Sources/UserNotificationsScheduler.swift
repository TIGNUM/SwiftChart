//
//  UserNotificationsScheduler.swift
//  QOT
//
//  Created by Sam Wyndham on 25/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import UserNotifications

/**
 Schedules `UNNotificationRequest`s and notifies delegate of changes.

 - Important:
 The API of `UNUserNotificationCenter` is a little limited for what we need. Unfortunately we will rely on some of it's
 undocumented features, gathered through experimentation and reading online. These are:

 1. A maximum of 64 notifications can be scheduled at one time.
 2. Functions on `UNUserNotificationCenter` operate on a FIFO queue. For example, despite
 `removeAllPendingNotificationRequests()` working asyncronously, calling
 `getPendingNotificationRequests(completionHandler:)` directly after will always return 0 `UNNotificationRequest`s.
*/
final class UserNotificationsScheduler {

    typealias ScheduledNotificationsChangeHandler = (_ ids: Set<String>) -> Void

    private let center: UNUserNotificationCenter
    private let queue = DispatchQueue(label: "UserNotificationsScheduler", qos: .background)
    private var updateHandler: ScheduledNotificationsChangeHandler?
    private var scheduledNotificationIDs: Set<String> = []
    private let calendar: Calendar

    init(center: UNUserNotificationCenter, calendar: Calendar) {
        self.center = center
        self.calendar = calendar
    }

    func onChange(_ handler: @escaping ScheduledNotificationsChangeHandler) {
        updateHandler = handler
        queue.async { self._updateScheduledNotificationIDs() }
    }

    func scheduleNotifications(_ requests: [UNNotificationRequest], now: Date = Date()) {
        queue.async { self._scheduleNotifications(requests, now: now) }
    }

    func removeNotifications(withIdentifiers identifiers: [String]) {
        queue.async { self._removeNotifications(withIdentifiers: identifiers)}
    }

    // MARK: The following methods must be called on `queue`!

    private func _updateScheduledNotificationIDs() {
        center.getPendingNotificationRequests { [weak self] (requests) in
            self?._updateScheduledNotificationIDs(requests: requests)
        }
    }

    private func _scheduleNotifications(_ requests: [UNNotificationRequest], now: Date) {
        let futureRequests: [(request: UNNotificationRequest, triggerDate: Date)] = requests.flatMap { request in
            guard let triggerDate = request.nextTriggerDate(), triggerDate >= now else { return nil }
            return (request, triggerDate)
        }
        let first64Requests = futureRequests.sorted { $0.triggerDate < $1.triggerDate }.prefix(64)
        let needsScheduling = first64Requests.filter { !scheduledNotificationIDs.contains($0.request.identifier) }
        center.scheduleNofications(needsScheduling.map({ $0.request }), queue: queue) { [weak self] (pending) in
            self?._updateScheduledNotificationIDs(requests: pending)
        }
    }

    func _removeNotifications(withIdentifiers identifiers: [String]) {
        center.removeNotifications(withIdentifiers: identifiers, queue: queue) { [weak self] (pending) in
            self?._updateScheduledNotificationIDs(requests: pending)
        }
    }

    private func _updateScheduledNotificationIDs(requests: [UNNotificationRequest]) {
        let ids = Set(requests.map({ $0.identifier }))
        if scheduledNotificationIDs != ids {
            scheduledNotificationIDs = ids
            updateHandler?(ids)
        }
    }
}

extension UNUserNotificationCenter {

    func scheduleNofications(_ requests: [UNNotificationRequest],
                             queue: DispatchQueue,
                             completion: @escaping (_ pendingRequests: [UNNotificationRequest]) -> Void) {
        let dispatchGroup = DispatchGroup()
        for request in requests {
            dispatchGroup.enter()
            add(request) { (error) in
                if let error = error {
                    log("Failed to schedule user notification request: \(request), error: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: queue) { [weak self] in
            self?.getPendingNotificationRequests { (requests) in
                queue.async {
                    completion(requests)
                }
            }
        }
    }

    func removeNotifications(withIdentifiers identifiers: [String],
                             queue: DispatchQueue,
                             completion: @escaping (_ pendingRequests: [UNNotificationRequest]) -> Void) {
        removePendingNotificationRequests(withIdentifiers: identifiers)
        removeDeliveredNotifications(withIdentifiers: identifiers)
        getPendingNotificationRequests { (requests) in
            queue.async {
                completion(requests)
            }
        }
    }
}

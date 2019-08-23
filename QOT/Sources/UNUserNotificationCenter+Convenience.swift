//
//  UNUserNotificationCenter+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 25/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import UserNotifications

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
}

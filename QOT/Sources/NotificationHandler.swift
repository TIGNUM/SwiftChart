//
//  NotificationHandler.swift
//  QOT
//
//  Created by Sam Wyndham on 16/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum UserInfo: String {
    case multiSelectionCounter
    case selectedAnswers
    case updatedAnswer

    func pair<T>(for value: T) -> (key: String, value: T) {
        return (self.rawValue, value)
    }
}

extension Notification.Name {
    static let logoutNotification = Notification.Name(rawValue: "qot_logoutNotification")
    static let showSigningInfoView = Notification.Name(rawValue: "qot_show_signing_info_view_controller")
    static let didUpdateSelectionCounter = Notification.Name(rawValue: "qot_decision_tree_multi_selection_counter")
}

final class NotificationHandler {
    let center: NotificationCenter
    var handler: ((Notification) -> Void)?

    init(center: NotificationCenter = .default, name: NSNotification.Name, object: Any? = nil) {
        self.center = center
        center.addObserver(self, selector: #selector(performHandler(notification:)), name: name, object: object)
    }

    // MARK: - private

    @objc private func performHandler(notification: Notification) {
        DispatchQueue.main.async {
            self.handler?(notification)
        }
    }
}

extension NotificationHandler {
    static func postNotification(withName name: NSNotification.Name,
                                 fromNotificationCenter notificationCenter: NotificationCenter = NotificationCenter.default,
                                 userInfo: [AnyHashable: Any]? = nil) {
        let notification = Notification(name: name, object: nil, userInfo: userInfo)
        notificationCenter.post(notification)
    }
}

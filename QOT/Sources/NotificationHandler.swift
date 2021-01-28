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
    case answerRemoteId

    func pair<T>(for value: T) -> (key: String, value: T) {
        return (self.rawValue, value)
    }
}

extension Notification.Name {
    static let logoutNotification = Notification.Name(rawValue: "qot_logoutNotification")
    static let showSigningInfoView = Notification.Name(rawValue: "qot_show_signing_info_view_controller")
    static let showSprintCards = Notification.Name(rawValue: "qot_show_daily_brief_sprint_cards")
    static let didUpdateSelectionCounter = Notification.Name(rawValue: "qot_decision_tree_multi_selection_counter")
    static let didSwitchSingleSelection = Notification.Name(rawValue: "qot_decision_tree_multi_did_switch_selection")
}

final class NotificationHandler {
    weak var center: NotificationCenter?
    var handler: ((Notification) -> Void)?

    init(center: NotificationCenter = .default, name: NSNotification.Name, object: Any? = nil) {
        self.center = center
        _ = center.addObserver(forName: name,
                           object: object,
                           queue: .main) { [weak self] notification in
            self?.performHandler(notification)
        }
    }

    // MARK: - private
    @objc private func performHandler(_ notification: Notification) {
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

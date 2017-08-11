//
//  NotificationHandler.swift
//  QOT
//
//  Created by Sam Wyndham on 16/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let logoutNotification = Notification.Name(rawValue: "qot_logoutNotification")
}

final class NotificationHandler {
    let center: NotificationCenter
    var handler: ((Notification) -> Void)?
    
    init(center: NotificationCenter = NotificationCenter.default, name: NSNotification.Name, object: Any? = nil) {
        self.center = center
        center.addObserver(self, selector: #selector(performHandler(notification:)), name: name, object: object)
    }

    // MARK: - private
    
    @objc private func performHandler(notification: Notification) {
        handler?(notification)
    }
}

extension NotificationHandler {
    static func postNotification(withName name: NSNotification.Name, fromNotificationCenter notificationCenter: NotificationCenter = NotificationCenter.default, userInfo: [AnyHashable : Any]? = nil) {
        let notification = Notification(name: name, object: nil, userInfo: userInfo)
        notificationCenter.post(notification)
    }
}

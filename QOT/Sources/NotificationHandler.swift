//
//  NotificationHandler.swift
//  QOT
//
//  Created by Sam Wyndham on 16/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class NotificationHandler {
    var handler: ((Notification) -> Void)?
    
    init(center: NotificationCenter = NotificationCenter.default, name: NSNotification.Name, object: Any?) {
        center.addObserver(self, selector: #selector(performHandler(notification:)), name: name, object: object)
    }
    
    @objc func performHandler(notification: Notification) {
        handler?(notification)
    }
}

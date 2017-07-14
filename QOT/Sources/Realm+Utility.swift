//
//  Realm+Utility.swift
//  QOT
//
//  Created by Lee Arromba on 14/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

extension NotificationToken {
    var handler: NotificationTokenHandler {
        return NotificationTokenHandler(notificationToken: self)
    }
}

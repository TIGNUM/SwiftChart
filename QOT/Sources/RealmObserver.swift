//
//  RealmObserver.swift
//  QOT
//
//  Created by Sam Wyndham on 26.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmObserver {

    private let realm: Realm
    private var notificationTokenHandler: NotificationTokenHandler?

    var handler: (() -> Void)?

    init(realm: Realm) {
        self.realm = realm

        notificationTokenHandler = realm.addNotificationBlock { [unowned self] (_, _) in
            self.handler?()
        }.handler
    }
}

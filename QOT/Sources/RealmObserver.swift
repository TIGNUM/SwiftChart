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
    private var token: NotificationToken?

    var handler: (() -> Void)?

    init(realm: Realm) {
        self.realm = realm

        token = realm.addNotificationBlock { [unowned self] (notification, realm) in
            self.handler?()
        }
    }
}

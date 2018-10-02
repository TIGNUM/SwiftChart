//
//  AppContent.swift
//  QOT
//
//  Created by karmic on 01.10.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class AppContent: SyncableObject {

    @objc dynamic var key: String = ""

    @objc dynamic var valueDescription: String = ""

    @objc dynamic var contentItemId: Int = 0
}

extension AppContent: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .appContent
    }

    func setData(_ data: AppContentIntermediary, objectStore: ObjectStore) throws {
        self.key = data.key
        self.valueDescription = data.description
        self.contentItemId = data.contentItemId
    }
}

//
//  EventTracker.swift
//  QOT
//
//  Created by Sam Wyndham on 13/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

/// Tracks events and persists them to the provided `Realm`.
final class EventTracker {
    private let realmProvider: () throws -> Realm
    private let queue = DispatchQueue(label: "com.tignum.qot.eventTracker", qos: .background)
    
    init(realmProvider: @escaping () throws -> Realm) {
        self.realmProvider = realmProvider
    }

    func track(page: PageID, referer: PageID?, associatedEntity: TrackableEntity?) {
        // FIXME: Implement
    }
}

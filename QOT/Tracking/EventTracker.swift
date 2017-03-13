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
    
    /// Tracks a `PageEvent`.
    ///
    /// - parameter page: The `PageID` of the tracked page.
    /// - parameter referer: The `PageID` of the refering page or `nil` if none exists.
    /// - parameter associatedEntity: The model object/entity associated with the page or `nil` if none exists.
    func track(page: PageID, referer: PageID?, associatedEntity: TrackableEntity?) {
        let associatedID = associatedEntity?.trackableEntityID
        
        queue.async {
            do {
                let event = PageEvent(pageID: page, referrerPageID: referer, associatedEntityID: associatedID)
                let realm = try self.realmProvider()
                try realm.write {
                    realm.add(event)
                }
            } catch let error {
                assertionFailure("Failed to create event: \(error)")
            }
        }
    }
}

//
//  EventTracker.swift
//  QOT
//
//  Created by Lee Arromba on 09/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

class EventTracker {
    var realmProvider: RealmProvider?
    
    enum Event {
        case didShowPage(TrackablePage, from: TrackablePage?)
    }
    
    static let `default` = EventTracker()
    
    func track(_ event: Event) {
        switch event {
        case .didShowPage(let trackablePage, let referrerTrackablePage):
            handleDidShowPage(trackablePage, from: referrerTrackablePage)
        }
    }
    
    // MARK: - private
    
    private func handleDidShowPage(_ trackablePage: TrackablePage, from referrerTrackablePage: TrackablePage?) {
        guard let realmProvider = realmProvider else {
            return
        }
        do {
            let realm = try realmProvider.realm()
            guard let associatedPage = trackablePage.associatedPage(realm: realm) else {
                return
            }
            try realm.write {
                realm.add(PageTrack(
                    page: associatedPage,
                    referrerPage: referrerTrackablePage?.associatedPage(realm: realm),
                    associatedValue: trackablePage.pageAssociatedObject?.object,
                    associatedValueType: trackablePage.pageAssociatedObject?.identifier,
                    referrerAssociatedValue: referrerTrackablePage?.pageAssociatedObject?.object,
                    referrerAssociatedValueType: referrerTrackablePage?.pageAssociatedObject?.identifier
                ))
            }
        } catch {
            log(error)
        }
    }
}

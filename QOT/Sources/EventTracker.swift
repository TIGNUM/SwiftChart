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

    private enum EventName: String {
        case contentItemRead = "event.contentitemread"
    }
    enum Event {
        case didShowPage(TrackablePage, from: TrackablePage?)
        case didReadContentItem(ContentItem)
    }
    
    let realmProvider: RealmProvider
    
    init(realmProvider: RealmProvider) {
        self.realmProvider = realmProvider
    }
        
    func track(_ event: Event) {
        switch event {
        case .didShowPage(let trackablePage, let referrerTrackablePage):
            handleDidShowPage(trackablePage, from: referrerTrackablePage)
        case .didReadContentItem(let contentItem):
            handleEvent(.contentItemRead, withObject: contentItem)
        }
    }
    
    // MARK: - private
    
    private func handleDidShowPage(_ trackablePage: TrackablePage, from referrerTrackablePage: TrackablePage?) {
        log("PAGE TRACK EVENT: \(String(describing: trackablePage.pageName)) from \(String(describing: referrerTrackablePage?.pageName))", enabled: LogToggle.Analytics.pageTracking)
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
                    associatedValueType: trackablePage.pageAssociatedObject?.identifier.rawValue,
                    referrerAssociatedValue: referrerTrackablePage?.pageAssociatedObject?.object,
                    referrerAssociatedValueType: referrerTrackablePage?.pageAssociatedObject?.identifier.rawValue
                ))
            }
        } catch {
            log(error)
        }
    }
    
    private func handleEvent(_ name: EventName, withObject object: SyncableObject) {
        log("EVENT: \(name.rawValue) withObject \(object.classForCoder)", enabled: LogToggle.Analytics.eventTracking)
        do {
            let realm = try realmProvider.realm()
            // FIXME: we shouldn't be sending events as PageTrack events
            guard let associatedPage = realm.objects(Page.self).filter({ $0.name == name.rawValue }).first else {
                return
            }
            try realm.write {
                realm.add(PageTrack(
                    page: associatedPage,
                    referrerPage: nil,
                    associatedValue: object,
                    associatedValueType: PageObject.Identifier.contentItem.rawValue,
                    referrerAssociatedValue: nil,
                    referrerAssociatedValueType: nil
                ))
            }
        } catch {
            log(error)
        }
    }
}

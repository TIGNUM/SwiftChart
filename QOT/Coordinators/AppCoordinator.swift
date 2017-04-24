//
//  AppCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift
import EventKit

final class AppCoordinator: ParentCoordinator {
    
    // MARK: - Properties
    
    fileprivate let window: UIWindow
    fileprivate var services: Services?
    fileprivate lazy var eventTracker: EventTracker = {
        return EventTracker(realmProvider: { return try Realm() })
    }()
    
    fileprivate lazy var calendarImportManager: CalendarImportManger = {
        let manager = CalendarImportManger(realm: { return try Realm() }, predicate: { (store) -> NSPredicate in
            let day: TimeInterval = 60 * 60 * 24
            let start = Date().addingTimeInterval(-(day * 7))
            let end = Date().addingTimeInterval(day * 7)
            return store.predicateForEvents(withStart: start, end: end, calendars: nil)
        })
        manager.delegate = self
        return manager
    }()
    
    var children = [Coordinator]()
    
    // MARK: - Life Cycle

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        Services.make { (result) in
            switch result {
            case .success(let services):
                self.services = services
                self.calendarImportManager.importEvents()
                self.startTabBarCoordinator(services: services)
            case .failure(_):
                // FIXME: Alert user that the app cannot be run
                break
            }
        }
    }

    private func startTabBarCoordinator(services: Services) {
        let tabBarCoordinator = TabBarCoordinator(
            window: self.window,
            selectedIndex: 0,
            services: services,
            eventTracker: self.eventTracker
        )
        tabBarCoordinator.start()
        self.startChild(child: tabBarCoordinator)
    }
}

extension AppCoordinator: CalendarImportMangerDelegate {

    func eventStoreAuthorizationRequired(for mangager: CalendarImportManger, currentStatus: EKAuthorizationStatus) {
        EKEventStore().requestAccess(to: .event) { (success, _) in
            if success {
                mangager.importEvents()
            } else {
                // FIXME: Handle error
            }
        }
    }
    
    func calendarImportDidFail(error: Error) {
        // FIXME: Handle error
        assertionFailure("Calendar import failed: \(error)")
    }
}

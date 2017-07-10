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
import Alamofire

final class AppCoordinator: ParentCoordinator {
    
    // MARK: - Properties
    
    fileprivate let window: UIWindow
    let secondaryWindow: UIWindow
    fileprivate var services: Services?
    fileprivate lazy var eventTracker: EventTracker = {
        return EventTracker(realmProvider: { return try Realm() })
    }()

    fileprivate lazy var syncManager: SyncManager = {
        let realmProvider = RealmProvider()
        let syncRecordService =  SyncRecordService(realmProvider: realmProvider)

        return SyncManager(networkManager: NetworkManager(), syncRecordService: syncRecordService, realmProvider: realmProvider)
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
        secondaryWindow = UIWindow(frame: UIScreen.main.bounds)
        configureSecondaryWindow()
    }
    
    func start() {
        Services.make { (result) in
            switch result {
            case .success(let services):
                self.services = services
                self.calendarImportManager.importEvents()
                self.startTabBarCoordinator(services: services)

                if MockToggle.json == false {
                    self.syncManager.syncAll()
                    self.syncManager.syncCalendarEvents()
                }
            case .failure:
                // TODO: localise alert text
                self.showAlert(type: .custom(title: "Error", message: "There was a problem initializing the app's data. Please restart the app and try again"), completion: {
                    exit(0)
                })
                break
            }
        }
    }

    func presentMorningInterview() {
        let morningInterViewController = MorningInterviewViewController()
        morningInterViewController.delegate = self
        switchToSecondaryWindow()
        secondaryWindow.rootViewController?.present(morningInterViewController, animated: true, completion: nil)
    }

    func showAlert(type: AlertType, completion: (() -> Void)? = nil) {
        switchToSecondaryWindow()
        secondaryWindow.rootViewController?.showAlert(type: type, handler: { [weak self] in
            completion?()
            self?.switchToMainWindow()
        })
    }

    private func switchToSecondaryWindow() {
        secondaryWindow.makeKeyAndVisible()
    }

    fileprivate func switchToMainWindow() {
        window.makeKeyAndVisible()
    }

    private func configureSecondaryWindow() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        secondaryWindow.rootViewController = viewController
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

// MARK: - CalendarImportMangerDelegate

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

// MARK: - MorningInterviewViewControllerDelegate

extension AppCoordinator: MorningInterviewViewControllerDelegate {

    func didTapClose(viewController: MorningInterviewViewController) {
        viewController.dismiss(animated: true) { 
            self.switchToMainWindow()
        }
    }
}

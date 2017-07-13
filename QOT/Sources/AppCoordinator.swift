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
import UserNotifications

final class AppCoordinator: ParentCoordinator {
    
    // MARK: - Properties
    
    let window: UIWindow
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
    lazy var remoteNotificationHandler: RemoteNotificationHandler = {
        return RemoteNotificationHandler(delegate: self)
    }()
    var children = [Coordinator]()
    
    // MARK: - Life Cycle

    init(window: UIWindow) {
        self.window = window
        secondaryWindow = UIWindow(frame: UIScreen.main.bounds)
        configureSecondaryWindow()
        remoteNotificationHandler.registerRemoteNotifications(completion: { (error: Error?) in
            // FIXME: handle error
        })
    }
    
    func start() {
        Services.make { (result) in
            switch result {
            case .success(let services):
                self.services = services
                self.calendarImportManager.importEvents()
                self.startTabBarCoordinator(services: services)

                // FIXME: remove this in production?
                if MockToggle.json == false {
                    self.syncManager.syncAll()
                    self.syncManager.syncCalendarEvents()
                }
            case .failure:
                // TODO: localise alert text
                self.showAlert(type: .custom(title: "Error", message: "There was a problem initializing the app's data. Please restart the app and try again"), handler: { 
                    exit(0)
                }, handlerDestructive: nil)

                break
            }
        }
    }

    func presentMorningInterview() {
        guard let questionService = services?.questionsService else {
            return
        }

        let questions = questionService.morningInterviewQuestions(questionGroupID: 100002)
        let viewModel = MorningInterviewViewModel(questions: questions)
        let morningInterViewController = MorningInterviewViewController(viewModel: viewModel)

        morningInterViewController.delegate = self
        switchToSecondaryWindow()
        secondaryWindow.rootViewController?.present(morningInterViewController, animated: true, completion: nil)
    }
    
    func presentWeeklyChoices(forStartDate startDate: Date, endDate: Date) {
        guard let contentCategories = services?.contentService.learnContentCategories() else {
            return
        }
        
        let viewModel = SelectWeeklyChoicesDataModel(data: contentCategories, maxSelectionCount: 5, startDate: startDate, endDate: endDate)
        let image = window.rootViewController?.view.screenshot()
        let viewController = SelectWeeklyChoicesViewController(delegate: self, viewModel: viewModel, backgroundImage: image)
        switchToSecondaryWindow()
        secondaryWindow.rootViewController?.present(viewController, animated: true, completion: nil)
    }

    func showAlert(type: AlertType, handler: (() -> Void)? = nil, handlerDestructive: (() -> Void)? = nil) {
        switchToSecondaryWindow()
        secondaryWindow.rootViewController?.showAlert(type: type, handler: { [weak self] in
            self?.switchToMainWindow()
            handler?()
        }, handlerDestructive: { [weak self] in
            self?.switchToMainWindow()
            handlerDestructive?()
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

// MARK: - SelectWeeklyChoicesViewControllerDelegate

extension AppCoordinator: SelectWeeklyChoicesViewControllerDelegate {
    func selectWeeklyChoicesViewController(_ viewController: SelectWeeklyChoicesViewController, selectedChoices choices: [WeeklyChoice]?) {
        choices?.forEach({ (choice: WeeklyChoice) in
            _ = try? services?.userService.createUserChoice(
                contentCategoryID: choice.categoryID,
                contentCollectionID: choice.contentCollectionID,
                startDate: choice.startDate,
                endDate: choice.endDate
            )
        })
        viewController.dismiss(animated: true) {
            self.switchToMainWindow()
        }
    }
    
    func selectWeeklyChoicesViewController(_ viewController: SelectWeeklyChoicesViewController, didSelectItem item: WeeklyChoice) {
        guard
            let services = services,
            let contentCollection = services.contentService.contentCollection(id: item.contentCollectionID),
            let category = services.contentService.contentCategory(id: item.categoryID) else {
            return
        }
        
        let coordinator = LearnContentItemCoordinator(
            root: viewController,
            services: services,
            eventTracker: eventTracker,
            content: contentCollection,
            category: category
        )
        startChild(child: coordinator)
    }
}

// MARK: - RemoteNotificationHandler

extension AppCoordinator: RemoteNotificationHandlerDelegate {
    func remoteNotificationHandler(_ remoteNotificationHandler: RemoteNotificationHandler, didReceiveNotification notification: UNNotification, withIdentifier identifier: String) {
        switch identifier {
        case RemoteNotificationHandler.LocalNotifcationIdentifier.interviewIdentifier:
            presentMorningInterview()
        case RemoteNotificationHandler.LocalNotifcationIdentifier.weeklyChoicesIdentifier:
            let userInfo = notification.request.content.userInfo
            guard let startDate = userInfo["startDate"] as? Date, let endDate = userInfo["endDate"] as? Date else {
                return
            }
            presentWeeklyChoices(forStartDate: startDate, endDate: endDate)
        default:
            break
        }
    }
    
    func remoteNotificationHandler(_ remoteNotificationHandler: RemoteNotificationHandler, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // FIXME: handle error
    }    
}

// MARK: - PrepareContentViewControllerDelegate

extension AppCoordinator: LearnContentItemViewControllerDelegate {
    // TODO: this implementation

    func didTapShare(in viewController: LearnContentItemViewController) {}
    
    func didTapVideo(with video: ContentItem, from view: UIView, in viewController: LearnContentItemViewController) {}
    
    func didTapArticle(with article: ContentItem, from view: UIView, in viewController: LearnContentItemViewController) {}
    
    func didChangeTab(to nextIndex: Index, in viewController: TopTabBarController) {}
    
    func didTapFinish(from view: UIView) {}
    
    func didSelectReadMoreContentCollection(with collectionID: Int, in viewController: LearnContentItemViewController) {}
    
    func didViewContentItem(id: Int, in viewController: LearnContentItemViewController) {}
}

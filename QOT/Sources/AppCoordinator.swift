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
import AirshipKit

final class AppCoordinator: ParentCoordinator {
    
    // MARK: - Properties
    
    let window: UIWindow
    let secondaryWindow: UIWindow
    var checkListIDToPresent: String?
    var children = [Coordinator]()
    lazy var logoutNotificationHandler: NotificationHandler = NotificationHandler(name: .logoutNotification)
    fileprivate var services: Services?
    fileprivate var tabBarCoordinator: TabBarCoordinator?
    fileprivate lazy var permissionHandler: PermissionHandler = PermissionHandler()
    fileprivate lazy var networkManager: NetworkManager = NetworkManager(delegate: self, credentialsManager: self.credentialsManager)
    fileprivate lazy var credentialsManager: CredentialsManager = CredentialsManager()

    fileprivate lazy var syncManager: SyncManager = {
        let realmProvider = RealmProvider()
        let syncRecordService =  SyncRecordService(realmProvider: realmProvider)
        let networkManager = self.networkManager

        return SyncManager(networkManager: networkManager, syncRecordService: syncRecordService, realmProvider: realmProvider)
    }()

    fileprivate lazy var calendarImportManager: CalendarImportManger = {
        let manager = CalendarImportManger(realm: RealmProvider(), predicate: { (store: EKEventStore) -> NSPredicate in
            let day: TimeInterval = 60 * 60 * 24
            let start = Date().addingTimeInterval(-(day * 7))
            let end = Date().addingTimeInterval(day * 7)
            let calendars = EKEventStore.shared.syncEnabledCalendars

            return store.predicateForEvents(withStart: start, end: end, calendars: calendars)
        })
        manager.delegate = self

        return manager
    }()

    // MARK: - Life Cycle

    init(window: UIWindow) {
        self.window = window
        secondaryWindow = UIWindow(frame: UIScreen.main.bounds)
        configureSecondaryWindow()

        logoutNotificationHandler.handler = { [weak self] (_: Notification) in
            self?.restart()
        }
    }
    
    func start() {
        let viewController = AnimatedLaunchScreenViewController()
        window.rootViewController = viewController
        window.makeKeyAndVisible()

        viewController.fadeInLogo()
        viewController.startAnimatingImages {
            viewController.fadeOutLogo { [unowned self] in
                if self.credentialsManager.isCredentialValid {
                    self.showApp()
                } else {
                    self.showLogin()
                }
            }
        }
    }

    func restart() {
        secondaryWindow.clear()
        removeAllChildren()
        logout()
        showLogin()
    }

    func showApp() {
        guard OnboardingCoordinator.isOnboardingComplete == true else {
            showOnboarding()
            return
        }
        
        Services.make { (result) in
            switch result {
            case .success(let services):
                self.registerRemoteNotifications()
                self.services = services
                self.calendarImportManager.importEvents()
                self.startTabBarCoordinator(services: services, permissionHandler: self.permissionHandler)
                self.syncManager.upSyncAll()
                self.syncManager.syncAll()
            case .failure:
                // TODO: localise alert text
                self.showAlert(type: .custom(title: "Error", message: "There was a problem initializing the app's data. Please restart the app and try again"), handler: {
                    exit(0)
                }, handlerDestructive: nil)
                
                break
            }
        }
    }

    func appDidBecomeActive() {
        services?.userService.updateTimeZone()
    }
}

// MARK: - private

private extension AppCoordinator {

    func registerRemoteNotifications() {
        permissionHandler.askPermissionForRemoteNotifications { (granted: Bool) in
            UAirship.push().userPushNotificationsEnabled = granted
        }
    }

    func switchToSecondaryWindow() {
        secondaryWindow.makeKeyAndVisible()
    }

    func switchToMainWindow() {
        window.makeKeyAndVisible()
    }

    func configureSecondaryWindow() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        secondaryWindow.rootViewController = viewController
    }

    func startTabBarCoordinator(services: Services, permissionHandler: PermissionHandler) {
        let selectedIndex = checkListIDToPresent != nil ? 2 : 0
        tabBarCoordinator = TabBarCoordinator(
            window: self.window,
            selectedIndex: selectedIndex,
            services: services,
            permissionHandler: permissionHandler
        )

        guard let tabBarCoordinator = tabBarCoordinator else { return }
        tabBarCoordinator.start()
        self.startChild(child: tabBarCoordinator)

        guard let localID = checkListIDToPresent else { return }
        tabBarCoordinator.showPreparationCheckList(localID: localID)
        checkListIDToPresent = nil
    }
}

// MARK: - Navigation

extension AppCoordinator {

    func presentPreparationCheckList(localID: String) {
        if services != nil {
            tabBarCoordinator?.showPreparationCheckList(localID: localID)
        } else {
            checkListIDToPresent = localID
        }
    }

    func presentMorningInterview(groupID: Int) {
        guard let services = services else {
            return
        }

        let viewModel = MorningInterviewViewModel(services: services, questionGroupID: groupID)
        let morningInterViewController = MorningInterviewViewController(viewModel: viewModel)

        morningInterViewController.delegate = self
        switchToSecondaryWindow()
        secondaryWindow.rootViewController?.present(morningInterViewController, animated: true, completion: nil)
    }

    func presentWeeklyChoices(forStartDate startDate: Date, endDate: Date) {
        guard let services = services else {
            return
        }

        let viewModel = SelectWeeklyChoicesDataModel(services: services, maxSelectionCount: Layout.MeSection.maxWeeklyPage, startDate: startDate, endDate: endDate)
        let image = window.rootViewController?.view.screenshot()
        let viewController = SelectWeeklyChoicesViewController(delegate: self, viewModel: viewModel, backgroundImage: image)
        switchToSecondaryWindow()
        secondaryWindow.rootViewController?.present(viewController, animated: true, completion: nil)
    }

    func presentArticleView(contentID: Int) {
        guard
            let root = window.rootViewController,
            let services = services,
            let coordinator = ArticleContentItemCoordinator(
                root: root,
                services: services,
                contentCollection: services.contentService.contentCollection(id: contentID),
                articleHeader: nil,
                topTabBarTitle: R.string.localized.sidebarTitleLibrary().uppercased()) else {
                    return
        }
        startChild(child: coordinator)
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

    func showOnboarding() {
        let coordinator = OnboardingCoordinator(window: window, delegate: self, permissionHandler: permissionHandler)
        startChild(child: coordinator)
    }

    func showLogin() {
        let loginCoordinator = LoginCoordinator(window: window, delegate: self, networkManager: networkManager)
        startChild(child: loginCoordinator)
    }

    func logout() {
        credentialsManager.clear()
        do {
            try syncManager.clearAll()
        } catch {
            // TODO: handle error
        }
    }

    func showTutorial(_ tutorial: Tutorials, buttonFrame: CGRect?, completion: @escaping () -> Void) {

        switch tutorial {
        default:
            let vm = TutorialViewModel(tutorial: tutorial, buttonFrame: buttonFrame, completion: completion)
            let viewController = TutorialViewController(viewModel: vm, delegate: self)

            self.switchToSecondaryWindow()
            self.secondaryWindow.rootViewController = viewController
        }
    }
}

// MARK: - TutorialViewControllerDelegate

extension AppCoordinator: TutorialViewControllerDelegate {

    func didCloseTutorial(completion: @escaping () -> Void) {
        print("didCloseTutorial")
        switchToMainWindow()
        secondaryWindow.rootViewController = nil
        completion()
    }
}

// MARK: - CalendarImportMangerDelegate

extension AppCoordinator: CalendarImportMangerDelegate {

    func eventStoreAuthorizationRequired(for mangager: CalendarImportManger, currentStatus: EKAuthorizationStatus) {
        permissionHandler.askPermissionForCalendar { (granted: Bool) in
            if granted == true {
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

// MARK: - LoginCoordinatorDelegate

extension AppCoordinator: LoginCoordinatorDelegate {

    func didLoginSuccessfully() {
        showApp()
    }
}

// MARK: - NetworkManagerDelegate

extension AppCoordinator: NetworkManagerDelegate {
    func networkManagerFailedToAuthenticate(_ networkManager: NetworkManager) {
        restart()
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
    func dismiss(viewController: SelectWeeklyChoicesViewController) {
        viewController.dismiss(animated: true) {
            self.switchToMainWindow()
        }
    }

    func didTapRow(_ viewController: SelectWeeklyChoicesViewController, contentCollection: ContentCollection, contentCategory: ContentCategory) {

        guard let services = services else { return }

        let coordinator = LearnContentItemCoordinator(
            root: viewController,
            services: services,
            content: contentCollection,
            category: contentCategory
        )
        startChild(child: coordinator)
    }
}

// MARK: - OnboardingCoordinatorDelegate

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingCoordinatorDidFinish(_ onboardingCoordinator: OnboardingCoordinator) {
        removeChild(child: onboardingCoordinator)
        showApp()
    }
}

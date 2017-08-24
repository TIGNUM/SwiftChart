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
    fileprivate var topTabBarController: UINavigationController?
    fileprivate var tabBarCoordinator: TabBarCoordinator?
    fileprivate lazy var permissionHandler: PermissionHandler = PermissionHandler()
    fileprivate lazy var networkManager: NetworkManager = NetworkManager(delegate: self, credentialsManager: self.credentialsManager)
    fileprivate lazy var credentialsManager: CredentialsManager = CredentialsManager()    

    fileprivate lazy var realmProvider: RealmProvider = {
        return RealmProvider()
    }()

    fileprivate lazy var databaseManager: DatabaseManager = {
        return DatabaseManager(config: RealmProvider.config)
    }()

    fileprivate lazy var pageTracker: PageTracker = {
        let tracker = PageTracker(eventTracker: self.eventTracker)
        PageTracker.setStaticTracker(pageTracker: tracker)
        return tracker
    }()

    fileprivate lazy var eventTracker: EventTracker = {
        return EventTracker()
    }()

    fileprivate lazy var syncRecordService: SyncRecordService = {
        return SyncRecordService(realmProvider: self.realmProvider)
    }()

    fileprivate lazy var syncManager: SyncManager = {
        return SyncManager(networkManager: self.networkManager, syncRecordService: self.syncRecordService, realmProvider: self.realmProvider)
    }()

    fileprivate lazy var calendarImportManager: CalendarImportManger = {
        let manager = CalendarImportManger(realm: self.realmProvider, predicate: { (store: EKEventStore) -> NSPredicate in
            let day: TimeInterval = 60 * 60 * 24
            let start = Date().addingTimeInterval(-(day * 30))
            let end = Date().addingTimeInterval(day * 30)
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
        if !databaseManager.isDatabaseCreated {
            do {
                try databaseManager.copyDefault(withName: .v1)
            } catch {
                log(error)
            }
        }
        eventTracker.realmProvider = realmProvider
        pageTracker.start()
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
        removeAllChildren()
        secondaryWindow.clear()
        logout()
        showLogin()
    }

    func showApp() {
        Services.make { (result) in
            switch result {
            case .success(let services):
                self.services = services
                self.syncManager.startAutoSync()
                self.syncManager.syncAll()
                self.syncManager.uploadMedia()

                guard OnboardingCoordinator.isOnboardingComplete == true else {
                    self.showOnboarding()
                    return
                }
                
                self.registerRemoteNotifications()
                self.calendarImportManager.importEvents()
                self.startTabBarCoordinator(services: services, permissionHandler: self.permissionHandler)
                
                // if the tab controller isn't loading, but we're still syncing all, show loading
                let doingInitialSync = self.syncManager.isSyncing && (self.syncManager.isDownloadRecordsValid == false)
                if let tabBarCoordinator = self.tabBarCoordinator, !tabBarCoordinator.isLoading, doingInitialSync {
                    tabBarCoordinator.showLoading()
                }
                self.updateDeviceToken()
            case .failure:
                // TODO: localise alert text
                self.showAlert(type: .custom(title: "Error", message: "There was a problem initializing the app's data. Please restart the app and try again"), handler: {
                    exit(0)
                }, handlerDestructive: nil)
            }
        }
    }

    func appDidBecomeActive() {
        services?.userService.updateTimeZone()
    }
}

// MARK: - private

private extension AppCoordinator {

    func updateDeviceToken() {
        guard
            let user = services?.userService.user(),
            let deviceToken = UAirship.push().deviceToken else {
                return
        }

        services?.userService.updateUserDeviceToken(user: user, deviceToken: deviceToken)
    }

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
        // create coordinator
        let selectedIndex = checkListIDToPresent != nil ? 2 : 0
        let coordinator = TabBarCoordinator(
            window: window,
            selectedIndex: selectedIndex,
            services: services,
            permissionHandler: permissionHandler,
            pageTracker: pageTracker
        )
        self.tabBarCoordinator = coordinator
        
        // start coordinator
        coordinator.start()
        startChild(child: coordinator)

        // apply any story logic that applies after start
        guard let localID = checkListIDToPresent else { return }
        coordinator.showPreparationCheckList(localID: localID)
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

    func presentMorningInterview(groupID: Int, validFrom: Date, validTo: Date) {
        guard let services = services else {
            return
        }

        let viewModel = MorningInterviewViewModel(services: services, questionGroupID: groupID, validFrom: validFrom, validTo: validTo)
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

    // TODO: The following 2 methods should be refactored
    func presentLearnContentItems(contentID: Int, categoryTitle: String) {

        guard
            let services = services,
            let content = services.contentService.contentCollection(id: contentID),
            let category = services.contentService.learnContentCategory(categoryTitle: categoryTitle),
            let rootViewController = window.rootViewController else {
                return
        }

        let presentationManager = CircularPresentationManager(originFrame: rootViewController.view.frame)
        let coordinator = LearnContentItemCoordinator(root: rootViewController, services: services, content: content, category: category, presentationManager: presentationManager, topBarDelegate: self)
        topTabBarController = coordinator.topTabBarController        
        switchToSecondaryWindow()
        secondaryWindow.rootViewController?.present(coordinator.topTabBarController, animated: true, completion: nil)
    }

    func presentLearnContentItems(contentID: Int, categoryID: Int) {

        guard
            let services = services,
            let content = services.contentService.contentCollection(id: contentID),
            let category = services.contentService.contentCategory(id: categoryID),
            let rootViewController = window.rootViewController else {
                return
        }

        let presentationManager = CircularPresentationManager(originFrame: rootViewController.view.frame)
        let coordinator = LearnContentItemCoordinator(root: rootViewController, services: services, content: content, category: category, presentationManager: presentationManager, topBarDelegate: self)
        topTabBarController = coordinator.topTabBarController
        switchToSecondaryWindow()
        secondaryWindow.rootViewController?.present(coordinator.topTabBarController, animated: true, completion: nil)
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
            syncManager.stopAutoSync()
            syncManager.stopCurrentSync(waitUntilStopped: true)
           
            let bundledDatabase = try databaseManager.loadDatabase(.v1)
            let currentDatabase = try realmProvider.realm()
            
            // FIXME: this doesn't work due to inverse relationships. Realm is unidirectional, so crashes with stack overflow (infinate loop) from recursively creating each direction.
            //try databaseManager.populateAllObjects(fromDatabase: fromDatabase, toDatabase: toDatabase)

            // For now we just delete all types that aren't in the bundled db
            let classNamesToKeep = Set(databaseManager.classNamesWithEntitiesFromDatabase(bundledDatabase))
            var classNamesToDelete = Set(databaseManager.classNamesFromDatabase(currentDatabase))
            classNamesToDelete.subtract(classNamesToKeep)
            let classNamesToDeleteArray = Array(classNamesToDelete)
            try syncRecordService.deleteSyncRecordsForClassNames(classNamesToDeleteArray)
            try databaseManager.deleteAllObjectsWithClassNames(classNamesToDeleteArray, fromDatabase: currentDatabase)
            bundledDatabase.invalidate()
        } catch {
            log(error.localizedDescription)
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

extension AppCoordinator: TopNavigationBarDelegate {

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController?.dismiss(animated: true, completion: nil)
        switchToMainWindow()
    }

    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
        guard let pageViewController = topTabBarController?.viewControllers.first as? PageViewController else {
            return
        }
        pageViewController.setPageIndex(index, animated: true)
    }

    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
        print("did select book mark")
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

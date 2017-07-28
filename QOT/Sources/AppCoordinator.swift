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

    var checkListIDToPresent: String?

    fileprivate var services: Services?
    fileprivate var tabBarCoordinator: TabBarCoordinator?
    
    fileprivate lazy var permissionHandler: PermissionHandler = {
        return PermissionHandler()
    }()
    fileprivate lazy var networkManager: NetworkManager = {
        return NetworkManager(delegate: self, credentialsManager: self.credentialsManager)
    }()
    fileprivate lazy var credentialsManager: CredentialsManager = {
        return CredentialsManager()
    }()
    fileprivate lazy var syncManager: SyncManager = {
        let realmProvider = RealmProvider()
        let syncRecordService =  SyncRecordService(realmProvider: realmProvider)
        let networkManager = self.networkManager
        return SyncManager(networkManager: networkManager, syncRecordService: syncRecordService, realmProvider: realmProvider)
    }()
    fileprivate lazy var calendarImportManager: CalendarImportManger = {
        let manager = CalendarImportManger(realm: RealmProvider(), predicate: { (store) -> NSPredicate in
            let day: TimeInterval = 60 * 60 * 24
            let start = Date().addingTimeInterval(-(day * 7))
            let end = Date().addingTimeInterval(day * 7)
            return store.predicateForEvents(withStart: start, end: end, calendars: nil)
        })
        manager.delegate = self
        return manager
    }()
    lazy var logoutNotificationHandler: NotificationHandler = {
        NotificationHandler(name: .logoutNotification)
    }()
    lazy var remoteNotificationHandler: RemoteNotificationHandler = {
        return RemoteNotificationHandler(delegate: self, permissionHandler: self.permissionHandler)
    }()
    var children = [Coordinator]()
    
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
            viewController.fadeOutLogo {
                if self.credentialsManager.isCredentialValid {
                    self.showApp()
                } else {
                    self.showLogin()
                }
            }
        }
    }

    func presentPreparationCheckList(localID: String) {

        if services != nil {
            tabBarCoordinator?.showPreparationCheckList(localID: localID)
        } else {
            checkListIDToPresent = localID
        }
    }

    func restart() {
        secondaryWindow.clear()
        removeAllChildren()
        logout()
        showLogin()
    }
    
    func presentMorningInterview() {
        guard let services = services else {
            return
        }

        let viewModel = MorningInterviewViewModel(services: services, questionGroupID: 100002)
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
    
    func showApp() {
        guard OnboardingCoordinator.isOnboardingComplete else {
            showOnboarding()
            return
        }
        Services.make { (result) in
            switch result {
            case .success(let services):
                self.remoteNotificationHandler.registerRemoteNotifications(completion: nil)
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

    // MARK: - private
    
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

    private func startTabBarCoordinator(services: Services, permissionHandler: PermissionHandler) {
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
            if granted {
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

// MARK: - OnboardingCoordinatorDelegate

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingCoordinatorDidFinish(_ onboardingCoordinator: OnboardingCoordinator) {
        removeChild(child: onboardingCoordinator)
        showApp()
    }
}

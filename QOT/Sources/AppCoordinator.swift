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
import Crashlytics

final class AppCoordinator: ParentCoordinator {
    
    // MARK: - Properties
    
    var checkListIDToPresent: String?
    var children = [Coordinator]()
    lazy var logoutNotificationHandler: NotificationHandler = NotificationHandler(name: .logoutNotification)
    lazy var apnsDeviceTokenRegistrar: APNSDeviceTokenRegistrar = APNSDeviceTokenRegistrar(networkManager: self.networkManager, credentialsManager: self.credentialsManager)
    private let windowManager: WindowManager
    private let remoteNotificationHandler: RemoteNotificationHandler
    private var services: Services?
    private var topTabBarController: UINavigationController?
    private var tabBarCoordinator: TabBarCoordinator?
    private lazy var permissionHandler: PermissionHandler = PermissionHandler()
    private lazy var networkManager: NetworkManager = NetworkManager(delegate: self, credentialsManager: self.credentialsManager)
    private lazy var credentialsManager: CredentialsManager = CredentialsManager.shared
    private var canProcessRemoteNotifications = false
    private var onDismiss: (() -> Void)?
    private var currentPresentedController: UIViewController?
    private var currentPresentedNavigationController: UINavigationController?
    static var currentStatusBarStyle: UIStatusBarStyle?
    
    private lazy var realmProvider: RealmProvider = {
        return RealmProvider()
    }()

    private lazy var pageTracker: PageTracker = {
        let tracker = PageTracker(eventTracker: self.eventTracker)
        PageTracker.setStaticTracker(pageTracker: tracker)
        return tracker
    }()

    private lazy var eventTracker: EventTracker = {
        return EventTracker(realmProvider: self.realmProvider)
    }()

    private lazy var syncRecordService: SyncRecordService = {
        return SyncRecordService(realmProvider: self.realmProvider)
    }()

    lazy var syncManager: SyncManager = {
        return SyncManager(networkManager: self.networkManager, syncRecordService: self.syncRecordService, realmProvider: self.realmProvider)
    }()

    private lazy var calendarImportManager: CalendarImportManger = {
        let manager = CalendarImportManger(realm: self.realmProvider, predicate: { () -> (start: Date, end: Date) in
            let day: TimeInterval = 60 * 60 * 24
            let start = Date().addingTimeInterval(-(day * 30))
            let end = Date().addingTimeInterval(day * 30)
            return (start, end)
        })
        manager.delegate = self

        return manager
    }()

    // MARK: - Life Cycle

    init(windowManager: WindowManager, remoteNotificationHandler: RemoteNotificationHandler) {
        self.windowManager = windowManager
        self.remoteNotificationHandler = remoteNotificationHandler
        
        remoteNotificationHandler.delegate = self
        logoutNotificationHandler.handler = { [weak self] (_: Notification) in
            self?.restart()
        }

        let locationManager = LocationManager()
        locationManager.startSignificantLocationMonitoring(didUpdateLocations: sendLocationUpdate)
    }
    
    func start() {
        pageTracker.start()
        observeTimeZoneChange()
        
        let viewController = AnimatedLaunchScreenViewController()
        windowManager.setRootViewController(viewController, atLevel: .normal, animated: false, completion: nil)
        viewController.fadeInLogo()
        viewController.startAnimatingImages {
            viewController.fadeOutLogo { [unowned self] in
                if self.credentialsManager.isCredentialValid == true {
                    self.showApp()
                } else {
                    self.showLogin()
                }
            }
        }
    }

    func restart() {
        removeAllChildren()
        windowManager.clearWindows()
        logout()
        showLogin()
    }

    func showApp() {
        func handleError(error: Error) {
            log("Error setting up database: \(error)")
            Crashlytics.sharedInstance().recordError(error)
            let message = "There was a problem initializing the app's data. Please restart the app and try again"
            self.showMajorAlert(type: .custom(title: "Error", message: message), handler: {
                exit(0)
            }, handlerDestructive: nil)
        }

        DatabaseManager.shared.onSetupComplete { (error) in
            if let error = error {
                handleError(error: error)
            } else {
                do {
                    let services = try Services()
                    self.services = services
                    self.syncManager.startAutoSync()
                    self.syncManager.syncAll(shouldDownload: true)
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
                    self.canProcessRemoteNotifications = true
                    self.remoteNotificationHandler.processOutstandingNotifications()
                } catch {
                    handleError(error: error)
                }

            }
        }
    }

    func appDidBecomeActive() {
        services?.userService.updateTimeZone()
    }

    func dismiss(_ viewController: UIViewController, level: WindowManager.Level) {
        viewController.dismiss(animated: true) { [unowned self] in
            self.windowManager.resignWindow(atLevel: level)
            self.onDismiss?()
            self.onDismiss = nil
        }

        AppCoordinator.updateStatusBarStyleIfNeeded()
    }

    static func updateStatusBarStyleIfNeeded() {
        if let statusBarStyle = AppCoordinator.currentStatusBarStyle {
            UIApplication.shared.statusBarStyle = statusBarStyle
            AppCoordinator.currentStatusBarStyle = nil
        }
    }

    func updateUserTotalUsageTime() {
        services?.userService.updateTotalUsageTime()
    }
    
    func sendLocationUpdate(location: CLLocation) {
        timeZoneDidChange()
        networkManager.performUserLocationUpdateRequest(location: location) { (netwerkError: NetworkError?) in
            if let error = netwerkError {
                log("Error while trying to update user location: \(error)")
            }
        }
    }
}

// MARK: - private

private extension AppCoordinator {
    
    func observeTimeZoneChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(timeZoneDidChange), name: .NSSystemTimeZoneDidChange, object: nil)
    }
        
    @objc func timeZoneDidChange() {
        services?.userService.updateTimeZone { [unowned self] in
            self.syncManager.syncAll(shouldDownload: false)
        }
    }

    func registerRemoteNotifications() {
        permissionHandler.askPermissionForRemoteNotifications { (granted: Bool) in
            UAirship.push().userPushNotificationsEnabled = granted
        }
    }

    func startTabBarCoordinator(services: Services, permissionHandler: PermissionHandler) {
        let selectedIndex = checkListIDToPresent != nil ? 2 : 0
        let coordinator = TabBarCoordinator(windowManager: windowManager,
                                            selectedIndex: selectedIndex,
                                            services: services,
                                            eventTracker: eventTracker,
                                            permissionHandler: permissionHandler,
                                            pageTracker: pageTracker,
                                            syncManager: syncManager,
                                            networkManager: networkManager)
        self.tabBarCoordinator = coordinator
        coordinator.start()
        startChild(child: coordinator)
        guard let localID = checkListIDToPresent else { return }
        coordinator.showPreparationCheckList(localID: localID)
        checkListIDToPresent = nil
    }
}

// MARK: - Navigation

extension AppCoordinator {
    
    func presentAddSensorView(viewController: UIViewController) {
        guard let services = services else { return }
        let coordinator = AddSensorCoordinator(root: viewController, services: services)
        startChild(child: coordinator)
        currentPresentedController = coordinator.addSensorViewController
    }

    // FIXME In the future when everything will change....
    func presentPreparationList() {        
        if let viewController = currentPresentedController {
            dismiss(viewController, level: .priority)
        }
        
        if let navigationController = currentPresentedNavigationController {
            dismiss(navigationController, level: .priority)
        }

        guard let topViewController = AppDelegate.topViewController() else { return }

        if let tabBarController = topViewController as? TabBarController {
            selectTabBarITem(tabBarController: tabBarController, tabBarIndex: 2, topTabBarIndex: 1)
        } else if let pageViewController = topViewController as? PageViewController {
            pageViewController.viewControllers?.forEach { viewController in
                viewController.dismiss(animated: true) {
                    self.presentPreparationList()
                }
            }
        } else {
            topViewController.dismiss(animated: true) {
                self.presentPreparationList()
            }
        }
    }

    private func selectTabBarITem(tabBarController: TabBarController, tabBarIndex: Index, topTabBarIndex: Index) {
        tabBarController.tabBarView.setSelectedIndex(tabBarIndex, animated: true)
        tabBarController.didSelectItem(index: tabBarIndex)

        guard
            let topNavigationBar = (tabBarCoordinator?.topTabBarControllerPrepare.navigationBar as? TopNavigationBar),
            let myPrepButton = (topNavigationBar.middleButtons?.filter { $0.tag == topTabBarIndex })?.first else {
                return
        }

        tabBarCoordinator?.topNavigationBar(TopNavigationBar(), middleButtonPressed: myPrepButton, withIndex: topTabBarIndex, ofTotal: 2)
        topNavigationBar.setIndicatorToButtonIndex(topTabBarIndex)
    }

    func presentToBeVision() {
        guard let services = services else { return }
        let viewModel = MyToBeVisionViewModel(services: services)
        let myToBeVisionViewController = MyToBeVisionViewController(viewModel: viewModel, permissionHandler: permissionHandler)
        myToBeVisionViewController.delegate = self
        windowManager.showWindow(atLevel: .priority)
        windowManager.presentViewController(myToBeVisionViewController, atLevel: .priority, animated: true, replacesContent: true, completion: nil)
        currentPresentedController = myToBeVisionViewController
    }

    func presentPreparationCheckList(localID: String) {
        if services != nil {
            tabBarCoordinator?.showPreparationCheckList(localID: localID)
        } else {
            checkListIDToPresent = localID
        }
    }

    func presentMorningInterview(groupID: Int, validFrom: Date, validTo: Date) {
        guard let services = services else { return }
        AppCoordinator.currentStatusBarStyle = UIApplication.shared.statusBarStyle
        let viewModel = MorningInterviewViewModel(services: services, questionGroupID: groupID, validFrom: validFrom, validTo: validTo)
        let morningInterViewController = MorningInterviewViewController(viewModel: viewModel)
        morningInterViewController.delegate = self
        windowManager.showWindow(atLevel: .priority)
        windowManager.presentViewController(morningInterViewController, atLevel: .priority, animated: true, replacesContent: true, completion: nil)
        currentPresentedController = morningInterViewController
    }

    func presentWeeklyChoices(forStartDate startDate: Date, endDate: Date, completion: (() -> Void)?) {
        guard let services = services else { return}
        onDismiss = completion
        AppCoordinator.currentStatusBarStyle = UIApplication.shared.statusBarStyle
        let viewModel = SelectWeeklyChoicesDataModel(services: services, maxSelectionCount: Layout.MeSection.maxWeeklyPage, startDate: startDate, endDate: endDate)
        let image = windowManager.rootViewController(atLevel: .normal)?.view.screenshot()
        let viewController = SelectWeeklyChoicesViewController(delegate: self, viewModel: viewModel, backgroundImage: image)
        windowManager.showWindow(atLevel: .priority)
        windowManager.presentViewController(viewController, atLevel: .priority, animated: true, replacesContent: true, completion: nil)
        currentPresentedController = viewController
    }

    // FIXME: REFACTOR THIS
    func presentLearnContentItems(contentID: Int) {
        guard
            let services = services,
            let content = services.contentService.contentCollection(id: contentID),
            let category = content.contentCategories.first,
            let rootViewController = windowManager.rootViewController(atLevel: .normal) else {
                return
        }

        // FIXME: do we need to use the coordinator?
        AppCoordinator.currentStatusBarStyle = UIApplication.shared.statusBarStyle
        let presentationManager = ContentItemAnimator(originFrame: rootViewController.view.frame)
        let coordinator = LearnContentItemCoordinator(root: rootViewController, eventTracker: eventTracker, services: services, content: content, category: category, presentationManager: presentationManager, topBarDelegate: self)
        topTabBarController = coordinator.topTabBarController
        windowManager.showWindow(atLevel: .priority)
        windowManager.presentViewController(coordinator.topTabBarController, atLevel: .priority, animated: true, replacesContent: true, completion: nil)
        currentPresentedNavigationController = coordinator.topTabBarController
    }

    // FIXME: REFACTOR THIS
    func presentLearnContentItems(contentID: Int, categoryID: Int) {
        guard
            let services = services,
            let content = services.contentService.contentCollection(id: contentID),
            let category = services.contentService.contentCategory(id: categoryID),
            let rootViewController = windowManager.rootViewController(atLevel: .normal) else {
                return
        }

        // FIXME: do we need to use the coordinator?
        AppCoordinator.currentStatusBarStyle = UIApplication.shared.statusBarStyle
        let presentationManager = ContentItemAnimator(originFrame: rootViewController.view.frame)
        let coordinator = LearnContentItemCoordinator(root: rootViewController, eventTracker: eventTracker, services: services, content: content, category: category, presentationManager: presentationManager, topBarDelegate: self)
        topTabBarController = coordinator.topTabBarController        
        windowManager.showWindow(atLevel: .priority)
        windowManager.presentViewController(coordinator.topTabBarController, atLevel: .priority, animated: true, replacesContent: true, completion: nil)
        currentPresentedNavigationController = coordinator.topTabBarController
    }

    func showMajorAlert(type: AlertType, handler: (() -> Void)? = nil, handlerDestructive: (() -> Void)? = nil) {
        let alert = UIViewController.alert(forType: type, handler: {
            self.windowManager.resignWindow(atLevel: .alert)
            handler?()
        }, handlerDestructive: {
            self.windowManager.resignWindow(atLevel: .alert)
            handlerDestructive?()
        })
        windowManager.showWindow(atLevel: .alert)
        windowManager.presentViewController(alert, atLevel: .alert, animated: true, completion: nil)
        currentPresentedController = alert
    }

    func showOnboarding() {
        let userName = services?.userService.user()?.givenName ?? ""
        let coordinator = OnboardingCoordinator(windowManager: windowManager, delegate: self, permissionHandler: permissionHandler, userName: userName)
        startChild(child: coordinator)
    }

    func showLogin() {
        let loginCoordinator = LoginCoordinator(windowManager: windowManager, delegate: self, networkManager: networkManager)
        startChild(child: loginCoordinator)
    }

    func logout() {
        credentialsManager.clear()
        do {
            syncManager.stopAutoSync()
            syncManager.stopCurrentSync()

            try DatabaseManager.shared.resetDatabase(syncRecordService: syncRecordService)
        } catch {
            log(error.localizedDescription)
        }
    }
}

extension AppCoordinator: TopNavigationBarDelegate {

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController?.dismiss(animated: true) {
            self.windowManager.resignWindow(atLevel: .priority)
        }

        AppCoordinator.updateStatusBarStyleIfNeeded()
    }

    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
        guard let pageViewController = topTabBarController?.viewControllers.first as? PageViewController else {
            return
        }
        
        pageViewController.setPageIndex(index, animated: true)
    }

    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
        log("did select book mark")
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

    func didTapClose(viewController: MorningInterviewViewController, userAnswers: [UserAnswer]) {
        if userAnswers.isEmpty == false {
            sendMorningInterviewResults(userAnswers)
        }
        dismiss(viewController, level: .priority)
        currentPresentedNavigationController = nil
        currentPresentedController = nil
    }
    
    private func sendMorningInterviewResults(_ userAnswers: [UserAnswer]) {
        networkManager.performUserFeedbackRequest(userAnswers: userAnswers) { result in
            switch result {
            case .success(let value):
                self.showFeedbackAlert(for: value)
            case .failure(let error):
                log("error: \(error)")
            }
        }
    }

    private func showFeedbackAlert(for feedback: UserAnswerFeedback) {
        guard let rootViewController = windowManager.rootViewController(atLevel: .alert) else {
            return
        }
        windowManager.showWindow(atLevel: .alert)
        rootViewController.showAlert(type: .custom(title: feedback.title, message: feedback.body), handler: {
            self.windowManager.resignWindow(atLevel: .alert)
        }, handlerDestructive: nil)
    }
}

// MARK: - SelectWeeklyChoicesViewControllerDelegate

extension AppCoordinator: SelectWeeklyChoicesViewControllerDelegate {

    func dismiss(viewController: SelectWeeklyChoicesViewController) {
        dismiss(viewController, level: .priority)
    }

    func didTapRow(_ viewController: SelectWeeklyChoicesViewController, contentCollection: ContentCollection, contentCategory: ContentCategory) {
        guard let services = services else { return }

        let coordinator = LearnContentItemCoordinator(
            root: viewController,
            eventTracker: eventTracker,
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

// MARK: - RemoteNotificationHandlerDelegate

extension AppCoordinator: RemoteNotificationHandlerDelegate {
    
    func remoteNotificationHandler(_ handler: RemoteNotificationHandler, canProcessNotificationResponse: UANotificationResponse) -> Bool {
        return canProcessRemoteNotifications
    }
}

// MARK: - MyToBeVisionViewControllerDelegate

extension AppCoordinator: MyToBeVisionViewControllerDelegate {

    func didTapClose(in viewController: MyToBeVisionViewController) {
        dismiss(viewController, level: .priority)
    }
}

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
import ReactiveKit
import Bond

final class AppCoordinator: ParentCoordinator, AppStateAccess {

    // MARK: - Properties

    var checkListIDToPresent: String?
    var children = [Coordinator]()
    lazy var logoutNotificationHandler: NotificationHandler = NotificationHandler(name: .logoutNotification)
    lazy var apnsDeviceTokenRegistrar: APNSDeviceTokenRegistrar = APNSDeviceTokenRegistrar(networkManager: self.networkManager, credentialsManager: self.credentialsManager)
    private let windowManager: WindowManager
    private let remoteNotificationHandler: RemoteNotificationHandler
    private let locationManager: LocationManager
    private var services: Services?
    private lazy var permissionsManager: PermissionsManager = PermissionsManager(delegate: self)
    private lazy var networkManager: NetworkManager = NetworkManager(delegate: self, credentialsManager: self.credentialsManager)
    private lazy var credentialsManager: CredentialsManager = CredentialsManager.shared
    private var canProcessRemoteNotifications = false
    private var canProcessLocalNotifications = false
    private var onDismiss: (() -> Void)?
    private var destination: AppCoordinator.Router.Destination?

    // current state
    private weak var tabBarCoordinator: TabBarCoordinator?
    private weak var topTabBarController: UINavigationController?
    private weak var currentPresentedController: UIViewController?
    private weak var currentPresentedNavigationController: UINavigationController?
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

    init(windowManager: WindowManager,
         remoteNotificationHandler: RemoteNotificationHandler,
         locationManager: LocationManager) {
        self.windowManager = windowManager
        self.remoteNotificationHandler = remoteNotificationHandler
        self.locationManager = locationManager

        AppDelegate.current.delegate = self
        AppCoordinator.appState.appCoordinator = self
        remoteNotificationHandler.delegate = self
        logoutNotificationHandler.handler = { [weak self] (_: Notification) in
            self?.restart()
        }

        locationManager.startSignificantLocationMonitoring(didUpdateLocations: sendLocationUpdate)
    }

    func start() {
        if Bundle.main.isFirstVersion {
            self.credentialsManager.clear()
        }
        UserDefault.lastInstaledAppVersion.setStringValue(value: Bundle.main.versionNumber)

        pageTracker.start()
        observeTimeZoneChange()

        let viewController = AnimatedLaunchScreenViewController()
        windowManager.show(viewController, animated: false, completion: {
            viewController.fadeInLogo()
            viewController.startAnimatingImages { [unowned viewController] in
                viewController.fadeOutLogo {
                    if self.credentialsManager.isCredentialValid {
                        self.showApp()
                    } else {
                        self.showLogin()
                    }
                }
            }
        })
    }

    func restart() {
        networkManager.cancelAllRequests()
        windowManager.clearWindows()
        removeAllChildren()
        logout()
        showLogin()
    }

    func showApp() {
        func handleError(error: Error) {
            log("Error setting up database: \(error)", level: .error)
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

                    // Setup AppState
                    AppCoordinator.appState.services = services

                    // Create missing database objects
                    if services.userService.myToBeVision() == nil {
                        let realm = try RealmProvider().realm()
                        try realm.write {
                            realm.add(MyToBeVision())
                        }
                    }

                    QOTUsageTimer.sharedInstance.userService = services.userService

                    self.syncManager.start()
                    guard OnboardingCoordinator.isOnboardingComplete == true else {
                        self.showOnboarding()
                        return
                    }

                    self.registerRemoteNotifications()
                    self.calendarImportManager.importEvents()
                    self.startTabBarCoordinator(services: services, permissionsManager: self.permissionsManager)
                    self.canProcessRemoteNotifications = true
                    self.canProcessLocalNotifications = true
                    self.remoteNotificationHandler.processOutstandingNotifications()
                    AppDelegate.current.processOutstandingNotifications()
                } catch {
                    handleError(error: error)
                }

            }
        }
    }

    func appDidBecomeActive() {
        services?.userService.updateTimeZone()
        permissionsManager.fetchHasUpdates { [unowned self] hasUpdates in
            self.reportPermissions(self.permissionsManager.allPermissions)
        }
    }

    func dismiss(_ viewController: UIViewController, level: WindowManager.Level, completion: (() -> Void)? = nil) {
        viewController.dismiss(animated: true) { [unowned self] in
            self.windowManager.resignWindow(atLevel: level)
            self.onDismiss?()
            self.onDismiss = nil
            completion?()
            if let destination = self.destination {
                self.navigate(to: destination)
            }
        }

        AppCoordinator.updateStatusBarStyleIfNeeded()
    }

    static func updateStatusBarStyleIfNeeded() {
        if let statusBarStyle = AppCoordinator.currentStatusBarStyle {
            UIApplication.shared.statusBarStyle = statusBarStyle
            AppCoordinator.currentStatusBarStyle = nil
        }
    }

    func sendLocationUpdate(location: CLLocation) {
        timeZoneDidChange()
        networkManager.performUserLocationUpdateRequest(location: location) { (error: NetworkError?) in
            if let error = error {
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
        permissionsManager.askPermission(for: [.remoteNotification]) { status in
            guard let status = status[.remoteNotification] else { return }
            UAirship.push().userPushNotificationsEnabled = status == .granted
        }
    }

    func startTabBarCoordinator(services: Services, permissionsManager: PermissionsManager) {
        let selectedIndex = checkListIDToPresent != nil ? 2 : 0
        let coordinator = TabBarCoordinator(windowManager: windowManager,
                                            selectedIndex: selectedIndex,
                                            services: services,
                                            eventTracker: eventTracker,
                                            permissionsManager: permissionsManager,
                                            pageTracker: pageTracker,
                                            syncManager: syncManager,
                                            networkManager: networkManager)
        self.tabBarCoordinator = coordinator
        startChild(child: coordinator)
        guard let localID = checkListIDToPresent else { return }
        coordinator.showPreparationCheckList(localID: localID)
        checkListIDToPresent = nil
    }
}

// MARK: - Navigation

extension AppCoordinator {

    func showMajorAlert(type: AlertType, handler: (() -> Void)? = nil, handlerDestructive: (() -> Void)? = nil) {
        let alert = UIViewController.alert(forType: type, handler: {
            self.windowManager.resignWindow(atLevel: .alert)
            handler?()
        }, handlerDestructive: {
            self.windowManager.resignWindow(atLevel: .alert)
            handlerDestructive?()
        })
        windowManager.showAlert(alert, animated: true, completion: nil)
        currentPresentedController = alert
    }

    func showOnboarding() {
        let userName = services?.userService.user()?.givenName ?? ""
        let coordinator = OnboardingCoordinator(windowManager: windowManager,
                                                delegate: self,
                                                permissionsManager: permissionsManager,
                                                userName: userName)
        startChild(child: coordinator)
    }

    func showLogin() {
        let loginCoordinator = LoginCoordinator(windowManager: windowManager,
                                                delegate: self,
                                                networkManager: networkManager,
                                                syncManager: syncManager)
        startChild(child: loginCoordinator)
    }

    func logout() {
        permissionsManager.reset()
        credentialsManager.clear()
        baseURL = URL(string: "https://esb.tignum.com")!
        do {
            syncManager.stop()

            try DatabaseManager.shared.resetDatabase(syncRecordService: syncRecordService)
        } catch {
            log(error.localizedDescription, level: .error)
        }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

extension AppCoordinator: TopNavigationBarDelegate {

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController?.dismiss(animated: true) {
            self.windowManager.resignWindow(atLevel: .priority)
        }

        AppCoordinator.updateStatusBarStyleIfNeeded()
    }

    func topNavigationBar(_ navigationBar: TopNavigationBar,
                          middleButtonPressed button: UIButton,
                          withIndex index: Int,
                          ofTotal total: Int) {
        guard let pageViewController = topTabBarController?.viewControllers.first as? PageViewController else { return }
        pageViewController.setPageIndex(index, animated: true)
    }

    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
        log("did select book mark")
    }
}

// MARK: - CalendarImportMangerDelegate

extension AppCoordinator: CalendarImportMangerDelegate {

    func eventStoreAuthorizationRequired(for mangager: CalendarImportManger, currentStatus: EKAuthorizationStatus) {
        permissionsManager.askPermission(for: [.calendar]) { status in
            guard let status = status[.calendar] else { return }
            if status == .granted {
                mangager.importEvents()
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

    func loginCoordinatorDidLogin(_ coordinator: LoginCoordinator) {
        removeChild(child: coordinator)
        QOTUsageTimer.sharedInstance.startTimer()
        if UserDefault.hasShownOnbordingSlideShowInAppBuild.stringValue == nil {
            let viewController = SlideShowViewController(configure: SlideShowConfigurator.make())
            windowManager.show(viewController, animated: true, completion: nil)
            UserDefault.hasShownOnbordingSlideShowInAppBuild.setStringValue(value: Bundle.main.buildNumber)
        } else {
            showApp()
        }
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

    func didTapClose(viewController: MorningInterviewViewController, userAnswers: [UserAnswer], notificationRemoteID: Int) {
        if userAnswers.isEmpty == false {
            sendMorningInterviewResults(userAnswers, viewController: viewController, notificationRemoteID: notificationRemoteID)
        } else {
            dismiss(viewController, level: .priority)
        }
    }

    private func sendMorningInterviewResults(_ userAnswers: [UserAnswer],
                                             viewController: MorningInterviewViewController,
                                             notificationRemoteID: Int) {
        self.dismiss(viewController, level: .priority)
        if let destination = URLScheme.guide.destination {
            self.navigate(to: destination)
        }

        networkManager.performUserAnswerFeedbackRequest(userAnswers: userAnswers) { result in
            switch result {
            case .success(let value):
                self.save(feedback: value, notificationRemoteID: notificationRemoteID) {}
            case .failure(let error):
                log("error: \(error)")
            }
        }
    }

    private func save(feedback: UserAnswerFeedback, notificationRemoteID: Int, completion: (() -> Void)?) {
        do {
            let realm = try RealmProvider().realm()
            if let interviewResult = realm.object(ofType: RealmInterviewResult.self, forPrimaryKey: notificationRemoteID) {
                try realm.write {
                    interviewResult.feedback = feedback.body
                }
            }
        } catch {
            log(error, level: .error)
            completion?()
        }
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

    func remoteNotificationHandler(_ handler: RemoteNotificationHandler,
                                   canProcessNotificationResponse: UANotificationResponse) -> Bool {
        return canProcessRemoteNotifications
    }
}

extension AppCoordinator: LocalNotificationHandlerDelegate {

    func localNotificationHandler(_ handler: AppDelegate, canProcessNotification: UNNotification) -> Bool {
        return canProcessLocalNotifications
    }
}

// MARK: - MyToBeVisionViewControllerDelegate

extension AppCoordinator: MyToBeVisionViewControllerDelegate {

    func didTapClose(in viewController: MyToBeVisionViewController) {
        dismiss(viewController, level: .priority)
    }
}

// MARK: - PermissionDelegate

extension AppCoordinator: PermissionManagerDelegate {

    func permissionManager(_ manager: PermissionsManager, didUpdatePermissions permissions: [PermissionsManager.Permission]) {
        reportPermissions(permissions)
    }

    private func reportPermissions(_ permissions: [PermissionsManager.Permission]) {
        permissionsManager.serializedJSONData(for: permissions) { [unowned self] data in
            guard let data = data else {
                assertionFailure("couldn't generate permissions json data")
                return
            }
            self.networkManager.performDevicePermissionsRequest(with: data, completion: { error in
                if let error = error {
                    log("failed to report permissions: \(error.localizedDescription)")
                } else {
                    log("successfully reported permissions: \(permissions.map({ $0.identifier }))")
                }
            })
        }
    }
}

// MARK: - LearnContentListCoordinatorDelegate

extension AppCoordinator: LearnContentListCoordinatorDelegate {

    func didFinish(coordinator: LearnContentListCoordinator) {
        if let index = children.index(where: { $0 === coordinator}) {
            children.remove(at: index)
        }
    }
}

// MARK: - Routing

extension AppCoordinator {

    struct Router {

        struct Destination {
            let tabBar: TabBar
            let topTabBar: TopTabBar
            let chatSection: ChatSection

            init(tabBar: TabBar, topTabBar: TopTabBar) {
                self.tabBar = tabBar
                self.topTabBar = topTabBar
                self.chatSection = .none
            }

            init(tabBar: TabBar, topTabBar: TopTabBar, chatSection: ChatSection) {
                self.tabBar = tabBar
                self.topTabBar = topTabBar
                self.chatSection = chatSection
            }
        }

        enum ChatSection {
            case problem
            case event
            case none

            var indexPath: IndexPath {
                switch self {
                case .problem: return IndexPath(item: 0, section: 1)
                case .event: return IndexPath(item: 1, section: 1)
                case .none: return IndexPath(item: 0, section: 0)
                }
            }
        }

        enum TabBar: Index {
            case guide = 0
            case learn = 1
            case me = 2
            case prepare = 3
        }

        enum TopTabBar {
            case guide
            case strategies
            case whatsHot
            case myData
            case myWhy
            case coach
            case myPrep

            var index: Index {
                switch self {
                case .guide: return 0
                case .strategies: return 0
                case .whatsHot: return 1
                case .myData: return 0
                case .myWhy: return 1
                case .coach: return 0
                case .myPrep: return 1
                }
            }

            func middleButton(_ topNavigationBar: TopNavigationBar?) -> UIButton? {
                if self == .guide { return nil }
                return (topNavigationBar?.middleButtons?.filter { $0.tag == index })?.first
            }

            func topNavigationBar(_ tabBarCoordinator: TabBarCoordinator?) -> TopNavigationBar? {
                return (tabBarCoordinator?.topTabBarControllerPrepare.navigationBar as? TopNavigationBar)
            }
        }
    }
}

extension AppCoordinator {

    func presentLearnContentItems(contentID: Int) {
        guard
            let services = services,
            let content = services.contentService.contentCollection(id: contentID),
            let category = content.contentCategories.first else { return }
        startLearnContentItemCoordinator(services: services, content: content, category: category)
    }

    func presentLearnContentItems(contentID: Int, categoryID: Int) {
        guard
            let services = services,
            let content = services.contentService.contentCollection(id: contentID),
            let category = services.contentService.contentCategory(id: categoryID) else { return }
        startLearnContentItemCoordinator(services: services, content: content, category: category)
    }

    private func startLearnContentItemCoordinator(services: Services,
                                                  content: ContentCollection,
                                                  category: ContentCategory) {
        AppCoordinator.currentStatusBarStyle = UIApplication.shared.statusBarStyle
        let presentationManager = ContentItemAnimator(originFrame: UIScreen.main.bounds)
        // FIXME: we shouldn't really init a coordinator just to get some child content
        let coordinator = LearnContentItemCoordinator(root: UIViewController(),
                                                      eventTracker: eventTracker,
                                                      services: services,
                                                      content: content,
                                                      category: category,
                                                      presentationManager: presentationManager,
                                                      topBarDelegate: self,
                                                      presentOnStart: false)
        startChild(child: coordinator)
        topTabBarController = coordinator.topTabBarController
        currentPresentedNavigationController = coordinator.topTabBarController
        windowManager.showPriority(coordinator.topTabBarController, animated: true, completion: nil)
    }

    func presentMeCharts(sector: StatisticsSectionType) {
        navigate(to: AppCoordinator.Router.Destination(tabBar: .me, topTabBar: .myData))
        tabBarCoordinator?.myUniverseViewController(nil, didTap: sector)
    }

    func navigate(to destination: AppCoordinator.Router.Destination) {
        self.destination = destination
        dismissCurrentPresentedControllers()
        guard let topViewController = AppDelegate.topViewController() else { return }

        if let tabBarController = topViewController as? TabBarController {
            selectTabBarItem(tabBarController: tabBarController, destination: destination)
        } else if let pageViewController = topViewController as? PageViewController {
            if let tabBarController = pageViewController.tabBarController as? TabBarController {
                selectTabBarItem(tabBarController: tabBarController, destination: destination)
            } else {
                pageViewController.viewControllers?.forEach { (viewController: UIViewController) in
                    if windowManager.presentedViewController(atLevel: .priority) == viewController {
                        dismiss(viewController, level: .priority) {
                            self.navigate(to: destination)
                        }
                    } else if windowManager.presentedViewController(atLevel: .normal) == viewController {
                        dismiss(viewController, level: .normal) {
                            self.navigate(to: destination)
                        }
                    } else {
                        viewController.dismiss(animated: true) {
                            self.navigate(to: destination)
                        }
                    }
                }
            }
        } else if let tabBarController = (topViewController as? MyUniverseViewController)?.parent as? TabBarController {
            selectTabBarItem(tabBarController: tabBarController, destination: destination)
        } else if let tabBarController = (topViewController as? LearnCategoryListViewController)?.parent as? TabBarController {
            selectTabBarItem(tabBarController: tabBarController, destination: destination)
        } else if let tabBarController = (topViewController as? GuideViewController)?.parent as? TabBarController {
            selectTabBarItem(tabBarController: tabBarController, destination: destination)
        } else {
            topViewController.dismiss(animated: true) {
                self.navigate(to: destination)
            }
        }
    }

    private func selectTabBarItem(tabBarController: TabBarController, destination: AppCoordinator.Router.Destination) {
        guard let viewControllers = tabBarController.viewControllers else { return }
        let tabBarIndex = destination.tabBar.rawValue
        let topTabBarIndex = destination.topTabBar.index
        tabBarController.selectedViewController = viewControllers[tabBarIndex]

        guard
            let topNavigationBar = destination.topTabBar.topNavigationBar(tabBarCoordinator),
            let middleButton = destination.topTabBar.middleButton(topNavigationBar),
            let destinationViewController = tabBarController.selectedViewController else { return }
        tabBarController.tabBarController(tabBarController, didSelect: destinationViewController)
        tabBarCoordinator?.topNavigationBar(topNavigationBar,
                                            middleButtonPressed: middleButton,
                                            withIndex: topTabBarIndex,
                                            ofTotal: 2)
        topNavigationBar.setIndicatorToButtonIndex(topTabBarIndex, animated: true)
        topNavigationBar.setIndicatorToButton(middleButton, animated: true)
        topNavigationBar.setIsSelected(middleButton)
        currentPresentedController = tabBarController.selectedViewController
    }

    func presentSideBar(guideItem: Guide.Item?) -> SidebarCoordinator? {
        dismissCurrentPresentedControllers()
        guard
            let rootViewController = windowManager.rootViewController(atLevel: .normal),
            let services = services else { return nil }
        let coordinator = SidebarCoordinator(root: rootViewController,
                                             services: services,
                                             syncManager: syncManager,
                                             networkManager: networkManager,
                                             permissionsManager: permissionsManager,
                                             guideItem: guideItem)
        startChild(child: coordinator)
        currentPresentedController = coordinator.sideBarViewController
        currentPresentedNavigationController = coordinator.topTabBarController

        return coordinator
    }

    func presentPreferencesSyncCalendar(guideItem: Guide.Item?) {
        guard let sidebarCoordinator = presentSideBar(guideItem: guideItem) else { return }
        sidebarCoordinator.didTapSettingsMenuCell(with: nil, in: sidebarCoordinator.sideBarViewController)
        guard let settingsMenuCoordinator = sidebarCoordinator.settingsMenuCoordinator else { return }
        let settingsMenuViewController = settingsMenuCoordinator.settingsMenuViewController
        settingsMenuCoordinator.didTapNotifications(in: settingsMenuViewController)
        guard let settingsCoordinator = settingsMenuCoordinator.settingsCoordinator else { return }
        startChild(child: settingsCoordinator)
//        windowManager.show(settingsCoordinator.settingsViewController, animated: true)
//        rootViewController.pushToStart(childViewController: settingsCoordinator.settingsViewController)
//        settingsMenuViewController.pushToStart(childViewController: settingsCoordinator.settingsViewController)
    }

    func presentLibrary() {
        guard let sidebarCoordinator = presentSideBar(guideItem: nil) else { return }
        sidebarCoordinator.didTapLibraryCell(in: sidebarCoordinator.sideBarViewController)
        currentPresentedController = sidebarCoordinator.sideBarViewController
    }

    func presentAddSensorView(viewController: UIViewController) {
        guard let services = services else { return }
        let coordinator = AddSensorCoordinator(root: viewController, services: services)
        startChild(child: coordinator)
        currentPresentedController = coordinator.addSensorViewController
    }

    func presentAddSensor() -> AddSensorCoordinator? {
        guard let sidebarCoordinator = presentSideBar(guideItem: nil) else { return nil }
        sidebarCoordinator.didTapAddSensorCell(with: nil, in: sidebarCoordinator.sideBarViewController)
        currentPresentedController = sidebarCoordinator.sideBarViewController
        return sidebarCoordinator.addSensorCoordinator
    }

    func presentFitbitAuthRefresh() {
        guard let addSensorCoordinator = presentAddSensor() else { return }
        addSensorCoordinator.didTapSensor(.fitbit, in: currentPresentedController ?? addSensorCoordinator.addSensorViewController)
    }

    func presentToBeVision() {
        guard let services = services else { return }
        let viewModel = MyToBeVisionViewModel(services: services)
        let myToBeVisionViewController = MyToBeVisionViewController(viewModel: viewModel,
                                                                    permissionsManager: permissionsManager)
        myToBeVisionViewController.delegate = self
        windowManager.showPriority(myToBeVisionViewController, animated: true, completion: nil)
        currentPresentedController = myToBeVisionViewController
    }

    func presentPreparationCheckList(localID: String) {
        if services != nil {
            tabBarCoordinator?.showPreparationCheckList(localID: localID)
        } else {
            checkListIDToPresent = localID
        }
    }

    func presentPrepare(_ destination: AppCoordinator.Router.Destination) {
        navigate(to: destination)
        guard let chatViewController = tabBarCoordinator?.prepareChatViewController else { return }
        chatViewController.destination = destination
        chatViewController.routerDelegate = self
    }

    func presentMorningInterview(groupID: Int,
                                 validFrom: Date,
                                 validTo: Date,
                                 notificationRemoteID: Int) {
        guard let services = services else { return }
        AppCoordinator.currentStatusBarStyle = UIApplication.shared.statusBarStyle
        let viewModel = MorningInterviewViewModel(services: services,
                                                  questionGroupID: groupID,
                                                  validFrom: validFrom,
                                                  validTo: validTo,
                                                  notificationRemoteID: notificationRemoteID)
        let morningInterViewController = MorningInterviewViewController(viewModel: viewModel)
        morningInterViewController.delegate = self
        windowManager.showPriority(morningInterViewController, animated: true, completion: nil)
        currentPresentedController = morningInterViewController
    }

    func presentWeeklyChoicesReminder() {
        guard
            let rootViewController = windowManager.rootViewController(atLevel: .normal),
            let services = services else { return }
        let coordinator = WeeklyChoicesCoordinator(root: rootViewController,
                                                   services: services,
                                                   transitioningDelegate: nil,
                                                   topBarDelegate: self)
        topTabBarController = coordinator.topTabBarController
        windowManager.showPriority(coordinator.topTabBarController, animated: true, completion: nil)
        currentPresentedNavigationController = coordinator.topTabBarController
    }

    func presentWeeklyChoices(forStartDate startDate: Date, endDate: Date, completion: (() -> Void)?) {
        guard let services = services else { return }
        onDismiss = completion
        AppCoordinator.currentStatusBarStyle = UIApplication.shared.statusBarStyle
        let viewModel = SelectWeeklyChoicesDataModel(services: services, maxSelectionCount: Layout.MeSection.maxWeeklyPage, startDate: startDate, endDate: endDate)
        let image = windowManager.rootViewController(atLevel: .normal)?.view.screenshot()
        let viewController = SelectWeeklyChoicesViewController(delegate: self, viewModel: viewModel, backgroundImage: image)
        windowManager.showPriority(viewController, animated: true, completion: nil)
        currentPresentedController = viewController
    }

    func presentFeatureArticelContentItems(contentID: Int, guideItem: Guide.Item) {
        guard
            let rootViewController = windowManager.rootViewController(atLevel: .normal),
            let services = services,
            let content = services.contentService.contentCollection(id: contentID),
            let coordinator = ArticleContentItemCoordinator(pageName: .featureExplainer,
                                                            root: rootViewController,
                                                            services: services,
                                                            contentCollection: content,
                                                            articleHeader: ArticleCollectionHeader(content: content),
                                                            topTabBarTitle: guideItem.subtitle.uppercased(),
                                                            shouldPush: false,
                                                            guideItem: guideItem) else { return }
        startChild(child: coordinator)
        currentPresentedNavigationController = coordinator.topTabBarController
        currentPresentedController = coordinator.fullViewController

    }

    func presentLearnContentCollection(collectionID: String?) {
        guard
            let rootViewController = windowManager.rootViewController(atLevel: .normal),
            let services = services else { return }
        let transitioningDelegate = LearnListAnimator()
        let coordinator = LearnContentListCoordinator(root: rootViewController,
                                                      transitioningDelegate: transitioningDelegate,
                                                      services: services,
                                                      eventTracker: eventTracker,
                                                      selectedCategoryIndex: 5,
                                                      originFrame: rootViewController.view.frame)
        coordinator.delegate = self
        startChild(child: coordinator)
    }

    func dismissCurrentPresentedControllers() {
        if let viewController = currentPresentedController {
            dismiss(viewController, level: .priority)
        }

        if let navigationController = currentPresentedNavigationController {
            dismiss(navigationController, level: .priority)
        }
    }
}

extension AppCoordinator: ChatViewControllerDelegate {

    func cellDidAppear(viewController: UIViewController,
                       collectionView: UICollectionView,
                       destination: AppCoordinator.Router.Destination?) {
        guard
            let chatViewController = viewController as? ChatViewController<Answer>,
            let indexPath = destination?.chatSection.indexPath else { return }
        chatViewController.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}

//
//  AppCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import UserNotifications
import AirshipKit
import Buglife
import qot_dal

final class AppCoordinator: ParentCoordinator, AppStateAccess {

    // MARK: - Properties

    private var isReadyToProcessURL = false

    var checkListIDToPresent: String?
    var children = [Coordinator]()
    private let windowManager: WindowManager
    private let remoteNotificationHandler: RemoteNotificationHandler
    private let locationManager: LocationManager
    private var services: Services?
    private var canProcessRemoteNotifications = false
    private var canProcessLocalNotifications = false
    private var isRestart = false
    private var onDismiss: (() -> Void)?
    private var destination: AppCoordinator.Router.Destination?
    private var iPadAdviceCompletion: (() -> Void)?
    private weak var topTabBarController: UINavigationController?
    private weak var currentPresentedController: UIViewController?
    private weak var currentPresentedNavigationController: UINavigationController?
    lazy var userLogoutNotificationHandler = NotificationHandler(name: .userLogout)
    lazy var automaticLogoutNotificationHandler = NotificationHandler(name: .automaticLogout)
    lazy var apnsDeviceTokenRegistrar = APNSDeviceTokenRegistrar()
    lazy var tabBarCoordinator: TabBarCoordinator? = {
        guard let services = services else { return nil }
        let selectedIndex = checkListIDToPresent != nil ? 2 : 0
        return TabBarCoordinator(windowManager: windowManager,
                                 selectedIndex: selectedIndex,
                                 services: services,
                                 eventTracker: eventTracker,
                                 permissionsManager: permissionsManager,
                                 pageTracker: pageTracker,
                                 syncManager: syncManager,
                                 networkManager: networkManager)
    }()
    lazy var networkManager: NetworkManager = {
        let manager = NetworkManager(delegate: self, authenticator: authenticator)
        AppCoordinator.appState.networkManager = manager
        return manager
    }()
    private lazy var permissionsManager: PermissionsManager = {
        let manager = PermissionsManager(delegate: self)
        AppCoordinator.appState.permissionsManager = manager
        return manager
    }()
    private lazy var authenticator = Authenticator()
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
    lazy var userLoggedIn: Bool = {
        return qot_dal.SessionService.main.getCurrentSession() != nil
    }()
    lazy var syncManager: SyncManager = {
        let manager = SyncManager(networkManager: self.networkManager,
                           syncRecordService: self.syncRecordService,
                           realmProvider: self.realmProvider)
        AppCoordinator.appState.syncManager = manager
        return manager
    }()

    lazy var calendarImportManager: CalendarImportManger = {
        let manager = CalendarImportManger(realm: self.realmProvider, predicate: { () -> (start: Date, end: Date) in
            let start = Date().dayBefore(days: 30)
            let end = Date().dayAfter(days: 30)
            return (start, end)
        })
        manager.delegate = self
        return manager
    }()

    private lazy var iPadAdviceView: IPadAdviceView? = {
        let advice = UINib(resource: R.nib.iPadAdviceView).instantiate(withOwner: nil, options: nil).first as? IPadAdviceView
        if
            let title = IPadAdviceViewType.title.value(contentService: services?.contentService),
            let body = IPadAdviceViewType.body.value(contentService: services?.contentService),
            let buttonDismiss = IPadAdviceViewType.buttonDismiss.value(contentService: services?.contentService),
            let buttonDoNotShow = IPadAdviceViewType.buttonDoNotShowAgain.value(contentService: services?.contentService) {
                advice?.setupView(title: title,
                                  body: body,
                                  buttonTitleDismiss: buttonDismiss,
                                  buttonTitleDoNotShow: buttonDoNotShow)
        }
        advice?.delegate = self
        return advice
    }()

    // MARK: - Life Cycle

    init(windowManager: WindowManager,
         remoteNotificationHandler: RemoteNotificationHandler,
         locationManager: LocationManager) {
        self.windowManager = windowManager
        self.remoteNotificationHandler = remoteNotificationHandler
        self.locationManager = locationManager
        AppDelegate.current.localNotificationHandlerDelegate = self
        AppDelegate.current.shortcutHandlerDelegate = self
        AppCoordinator.appState.appCoordinator = self
        remoteNotificationHandler.delegate = self
        userLogoutNotificationHandler.handler = { [weak self] (_: Notification) in
            self?.restart()
        }
        automaticLogoutNotificationHandler.handler = { [weak self] (_: Notification) in
            self?.restart()
        }
        locationManager.startSignificantLocationMonitoring(didUpdateLocations: sendLocationUpdate)
    }

    func basicSetup() {
        do {
            let services = try Services()
            self.services = services
            AppCoordinator.appState.services = services
        } catch {

        }
    }

    func start(completion: @escaping (() -> Void)) {
        if let navigationController = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController {
            if navigationController.viewControllers.first as? BaseRootViewController == nil {
                UIApplication.shared.delegate?.window??.rootViewController =
                    R.storyboard.bottomNavigation().instantiateInitialViewController()
            }
        } else {
            UIApplication.shared.delegate?.window??.rootViewController =
                R.storyboard.bottomNavigation().instantiateInitialViewController()
        }

        if Bundle.main.isFirstVersion == true {
            SessionService.main.logout()
        }
        UserDefault.lastInstaledAppVersion.setStringValue(value: Bundle.main.versionNumber)
        if UserDefault.firstInstallationTimestamp.object == nil {
            UserDefault.firstInstallationTimestamp.setObject(Date())
        }
        pageTracker.start()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        var setupError: Error?
        setupApp { error in
            setupError = error
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            if let error = setupError {
                self.handleSetupError(error: error)
            } else if qot_dal.SessionService.main.getCurrentSession() != nil {
                self.showApp()
                completion()
            } else {
                UserDefault.clearAllDataLogOut()
                self.showSigning()
            }
        }
    }

    func restart() {
        logout()
        ExtensionsDataManager.didUserLogIn(false)
        UIApplication.shared.shortcutItems?.removeAll()
        showSigning()
    }

    func setupBugLife() {
        guard authenticator.hasLoginCredentials() else { return }
        if qot_dal.SessionService.main.getCurrentSession()?.useremail?.lowercased().contains("@tignum.com") == true {
            Buglife.shared().start(withAPIKey: "fj62sZjDnl3g0dLuXJHUzAtt") // FIXME: obfuscate
            Buglife.shared().delegate = AppDelegate.current
            Buglife.shared().invocationOptions = [.shake]
        } else {
            Buglife.shared().delegate = nil
            Buglife.shared().invocationOptions = [.init(rawValue: 0)]
        }
    }

    private func setupApp(completion: @escaping (Error?) -> Void) {
        DatabaseManager.shared.onSetupComplete { (error) in
            if let error = error {
                completion(error)
            } else {
                do {
                    let services = try Services()
                    self.services = services
                    AppCoordinator.appState.services = services
                    QOTUsageTimer.sharedInstance.userService = services.userService
                    _ = self.tabBarCoordinator
                    self.setupBugLife()
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }

    func checkVersionIfNeeded() {
        guard services?.userService.user()?.appUpdatePrompt == true else { return }
    }

    private func handleSetupError(error: Error) {
        log("Error setting up database: \(error)", level: Logger.Level.error)
        let message = "There was a problem initializing the app's data. Please restart the app and try again"
        self.showMajorAlert(type: .custom(title: "Error", message: message), handler: {
            exit(0)
        })
    }

    func startSync() {
        self.syncManager.start()
    }

    func showApp() {
        RestartHelper().checkRestartURLAndRoute()
        self.isReadyToProcessURL = true
        ExtensionsDataManager.didUserLogIn(true)

        // Show coach marks on first launch (of v3.0 app)
        if !UserDefault.didShowCoachMarks.boolValue {
            UserDefault.didShowCoachMarks.setBoolValue(value: true)
            showCoachMarks()
            return
        }

        if self.isRestart == false {
            guard let coachCollectionViewController = R.storyboard.main().instantiateViewController(withIdentifier: "CoachCollectionViewController") as? CoachCollectionViewController,
            let rootViewController = R.storyboard.bottomNavigation().instantiateInitialViewController(),
            let rootNavigationController = rootViewController as? UINavigationController else {
                return
            }
            coachCollectionViewController.services = services
            if let baseVC = rootNavigationController.viewControllers.first as? BaseRootViewController {
                 baseVC.setContent(viewController: coachCollectionViewController)
            }
            self.windowManager.show(rootNavigationController, animated: true, completion: nil)
//            self.startTabBarCoordinator()
        } else {
            self.isRestart = false
            self.windowManager.rootViewController(atLevel: .normal)?.dismiss(animated: true, completion: nil)
        }
        self.registerRemoteNotifications()
        self.calendarImportManager.importEvents()
        self.canProcessRemoteNotifications = true
        self.canProcessLocalNotifications = true
        self.remoteNotificationHandler.processOutstandingNotifications()
        AppDelegate.current.processOutstandingNotifications()
        AppDelegate.current.processOutstandingShortcuts()
    }

    private func addMissingRealmObjectsAfterLogin() {
        guard let services = services else {
            let error = SimpleError(localizedDescription: "Missing services after login")
            log(error, level: Logger.Level.error)
            handleSetupError(error: error)
            return
        }

        do {
            if services.userService.myToBeVision() == nil {
                let headline = ScreenTitleService.main.toBeVisionHeadlinePlaceholder()?.uppercased()
                let text = ScreenTitleService.main.toBeVisionMessagePlaceholder()
                let realm = try RealmProvider().realm()
                try realm.write {
                    realm.add(MyToBeVision(headline: headline, text: text))
                }
            }
        } catch {
            handleSetupError(error: error)
        }
    }

    func appDidBecomeActive() {
        services?.userService.updateTimeZone()
        networkManager.performDeviceRequest()
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
    }

    func sendLocationUpdate(location: CLLocation) {
        guard authenticator.hasLoginCredentials() else { return }
        networkManager.performUserLocationUpdateRequest(location: location) { (error: NetworkError?) in
            if let error = error {
                log("Error while trying to update user location: \(error)", level: Logger.Level.error)
            }
        }
    }

    func sendAppEvent(_ event: AppEventRequest.EventType, date: Date = Date()) {

    }

    func isReadyToOpenURL() -> Bool {
        return isReadyToProcessURL
    }
}

// MARK: - private

private extension AppCoordinator {

    func showIpadSupportViewIfNeeded(completion: (() -> Void)?) {
        if UIDevice.isPad == true && UserDefault.iPadAdviceDoNotShowAgain.boolValue == false {
            if let iPadAdvice = iPadAdviceView {
                iPadAdvice.alpha = 0
                AppDelegate.topViewController()?.view.addSubview(iPadAdvice)
                iPadAdviceCompletion = completion
                UIView.animate(withDuration: Animation.duration_06) {
                    iPadAdvice.alpha = 1
                }
            }
        } else {
            completion?()
        }
    }

    func registerRemoteNotifications() {
        permissionsManager.askPermission(for: [.notifications]) { status in
            guard let status = status[.notifications] else { return }
            UAirship.push().userPushNotificationsEnabled = status == .granted
        }
    }

    func startTabBarCoordinator() {
        guard let tabBarCoordinator = tabBarCoordinator else { return }
        startChild(child: tabBarCoordinator)
        showSubscriptionReminderIfNeeded()
        guard let localID = checkListIDToPresent else { return }
        tabBarCoordinator.showPreparationCheckList(localID: localID)
        checkListIDToPresent = nil
    }

    func showSubscriptionReminderIfNeeded() {
        guard let user = services?.userService.user() else { return }
        let lastShownDate = UserDefault.subscriptionInfoShow.object as? Date
        if user.subscriptionExpired == true {
            windowManager.showSubscriptionReminder(isExpired: true)
        } else if user.subscriptionExpireSoon == true && (lastShownDate == nil || lastShownDate?.isToday == false) {
            UserDefault.subscriptionInfoShow.setObject(Date())
            windowManager.showSubscriptionReminder(isExpired: false)
        }
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

    func showTutorial() {
        let configurator = TutorialConfigurator.make()
        let controller = TutorialViewController(configure: configurator, from: .login)
        windowManager.show(controller, animated: true, completion: nil)
        UserDefault.hasShownOnbordingSlideShowInAppBuild.setStringValue(value: Bundle.main.buildNumber)
    }

    func showOnboarding() {
        let userName = self.services?.userService.user()?.givenName ?? ""
        let coordinator = OnboardingCoordinator(windowManager: windowManager,
                                                delegate: self,
                                                permissionsManager: permissionsManager,
                                                userName: userName)
        startChild(child: coordinator)
    }

    func showCoachMarks() {
        guard let controller = R.storyboard.walkthrough.walkthroughViewController() else { return }
        let configurator = WalkthroughConfigurator.make()
        configurator(controller)
        UIApplication.shared.delegate?.window??.rootViewController?.present(controller, animated: false, completion: nil)
    }

    func showSigning() {
        qot_dal.ContentService.main.getContentCategory(.Onboarding_3_0) { (contentCategory) in
            let landingConfigurator = OnboardingLandingPageConfigurator.make()
            let landingController = OnboardingLandingPageViewController()
            landingConfigurator(landingController, contentCategory)

            let navigationController = UINavigationController(rootViewController: landingController)
            navigationController.navigationBar.applyDefaultStyle()
            navigationController.modalTransitionStyle = .crossDissolve
            navigationController.modalPresentationStyle = .overFullScreen
            UIApplication.shared.delegate?.window??.rootViewController?.present(navigationController, animated: false, completion: nil)
        }
    }

    func logout() {
        permissionsManager.reset()
        setupBugLife()
        UserDefault.clearAllDataLogOut()
        environment.dynamicBaseURL = nil
        do {
            syncManager.stop()
            try DatabaseManager.shared.resetDatabase(syncRecordService: syncRecordService)
        } catch {
            log(error.localizedDescription, level: Logger.Level.error)
        }
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
    }

    func didLogin() {
        showApp()
    }
}

extension AppCoordinator: NavigationItemDelegate {

    func navigationItem(_ navigationItem: NavigationItem, leftButtonPressed button: UIBarButtonItem) {
        self.onDismiss?()
        self.onDismiss = nil
        topTabBarController?.dismiss(animated: true) {
            self.windowManager.resignWindow(atLevel: .priority)
        }
    }

    func navigationItem(_ navigationItem: NavigationItem, middleButtonPressedAtIndex index: Int, ofTotal total: Int) {
        guard let pageViewController = topTabBarController?.viewControllers.first as? PageViewController else { return }
        pageViewController.setPageIndex(index, animated: true)
    }

    func navigationItem(_ navigationItem: NavigationItem, rightButtonPressed button: UIBarButtonItem) {
        log("did select book mark", level: Logger.Level.info)
    }

    func navigationItem(_ navigationItem: NavigationItem, searchButtonPressed button: UIBarButtonItem) {}
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
        log("Calendar import failed: with error: \(error.localizedDescription))", level: Logger.Level.error)
        assertionFailure("Calendar import failed: \(error)")
    }
}

// MARK: - NetworkManagerDelegate

extension AppCoordinator: NetworkManagerDelegate {

    func networkManagerFailedToAuthenticate(_ networkManager: NetworkManager) {
        if authenticator.hasLoginCredentials() {
            authenticator.refreshSession { [weak self] (result) in
                switch result {
                case .failure(let error):
                    if error.isUnauthenticated {
                        self?.restart()
                    } else {
                        return
                    }
                default: return // do nothing
                }
            }
        } else {
            restart()
        }
    }
}

// MARK: - OnboardingCoordinatorDelegate

extension AppCoordinator: OnboardingCoordinatorDelegate {

    func onboardingCoordinatorDidFinish(_ onboardingCoordinator: OnboardingCoordinator) {
        removeChild(child: onboardingCoordinator)
        showApp()
    }
}

// MARK: - RemoteNotificationHandlerDelegate (Handle Response)

extension AppCoordinator: RemoteNotificationHandlerDelegate {

    func remoteNotificationHandler(_ handler: RemoteNotificationHandler,
                                   canProcessNotificationResponse: UANotificationResponse) -> Bool {
        return canProcessRemoteNotifications
    }
}

// MARK: - Handle incomming RemoteNotification

extension AppCoordinator {
    func handleIncommingNotificationDeepLinkURL(url: URL) {
        guard let host = url.host, let scheme = URLScheme(rawValue: host) else {
            return
        }

        switch scheme {
        case .toBeVision:
            services?.userService.setMyToBeVisionReminder(true)
        default:
            return
        }
    }
}

extension AppCoordinator: LocalNotificationHandlerDelegate {

    func localNotificationHandler(_ handler: AppDelegate, canProcessNotification: UNNotification) -> Bool {
        return canProcessLocalNotifications
    }
}

extension AppCoordinator: ShortcutHandlerDelegate {

    func shortcutHandler(_ handler: AppDelegate, canProcessShortcut shortcutItem: UIApplicationShortcutItem) -> Bool {
        return canProcessLocalNotifications
    }
}

// MARK: - PermissionDelegate

extension AppCoordinator: PermissionManagerDelegate {

    func permissionManager(_ manager: PermissionsManager,
                            didUpdatePermissions permissions: [PermissionsManager.Permission]) {
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
                    log("failed to report permissions: \(error.localizedDescription)", level: Logger.Level.info)
                } else {
                    log("successfully reported permissions: \(permissions.map({ $0.identifier }))", level: Logger.Level.info)
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
            let preferences: Preferences

            init(tabBar: TabBar, topTabBar: TopTabBar) {
                self.tabBar = tabBar
                self.topTabBar = topTabBar
                self.chatSection = .none
                self.preferences = .none
            }

            init(tabBar: TabBar, topTabBar: TopTabBar, chatSection: ChatSection) {
                self.tabBar = tabBar
                self.topTabBar = topTabBar
                self.chatSection = chatSection
                self.preferences = .none
            }

            init(preferences: Preferences) {
                self.tabBar = .guide // FIXME: The current impl. will ignore it, but we dont wanna change the tap
                self.topTabBar = .guide  // FIXME: The current impl. will ignore it, but we dont wanna change the tap
                self.chatSection = .none
                self.preferences = preferences
            }
        }

        enum ChatSection {
            case problem
            case event
            case none

            var indexPath: IndexPath {
                switch self {
                case .problem: return IndexPath(item: 0, section: 1)
                case .event: return IndexPath(item: 0, section: 1)
                case .none: return IndexPath(item: 0, section: 0)
                }
            }
        }

        enum Preferences {
            case calendarSync
            case notifications
            case none
        }

        enum TopTabBar {
            case guide
            case strategies
            case whatsHot
            case whatsHotList
            case toBeVision
            case data
            case coach
            case myPrep

            var index: Index? {
                switch self {
                case .guide: return nil
                case .strategies: return 0
                case .whatsHot: return 1
                case .whatsHotList: return 1
                case .toBeVision: return nil
                case .data: return nil
                case .coach: return 0
                case .myPrep: return 1
                }
            }
        }
    }
}

extension AppCoordinator {

    func presentComingEvent() {
        guard let preparationID = services?.preparationService.preparations().last?.localID else { return }
        presentPreparationCheckList(localID: preparationID)
    }

    func presentLearnContentItems(contentID: Int, guideItem: Guide.Item? = nil, onDismiss: (() -> Void)? = nil) {
        guard
            let services = services,
            let content = services.contentService.contentCollection(id: contentID),
            let category = content.contentCategories.first else { return }
        self.onDismiss = onDismiss
        startLearnContentItemCoordinator(services: services, content: content, category: category, guideItem: guideItem)
    }

    func presentLearnContentItems(contentID: Int, categoryID: Int) {
        guard
            let services = services,
            let content = services.contentService.contentCollection(id: contentID),
            let category = content.contentCategories.first else { return }
        startLearnContentItemCoordinator(services: services, content: content, category: category)
    }

    func startLearnContentItemCoordinator(services: Services,
                                                  content: ContentCollection,
                                                  category: ContentCategory,
                                                  guideItem: Guide.Item? = nil) {
        let presentationManager = ContentItemAnimator(originFrame: UIScreen.main.bounds)
        // FIXME: we shouldn't really init a coordinator just to get some child content
        let coordinator = LearnContentItemCoordinator(root: UIViewController(),
                                                      eventTracker: eventTracker,
                                                      services: services,
                                                      content: content,
                                                      category: category,
                                                      presentationManager: presentationManager,
                                                      topBarDelegate: self,
                                                      presentOnStart: false,
                                                      guideItem: guideItem)
        startChild(child: coordinator)
        topTabBarController = coordinator.topTabBarController
        currentPresentedNavigationController = coordinator.topTabBarController
        windowManager.showPriority(coordinator.topTabBarController, animated: true, completion: nil)
    }

    func presentMeCharts(sector: StatisticsSectionType) {
        navigate(to: AppCoordinator.Router.Destination(tabBar: .data, topTabBar: .data))
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

    func selectTabBarItem(tabBarController: TabBarController, destination: AppCoordinator.Router.Destination) {
        if destination.topTabBar == .whatsHot {
            presentWhatsHotArticle()
            return
        }

        guard let viewControllers = tabBarController.viewControllers else { return }
        let tabBarIndex = destination.tabBar.rawValue
        tabBarController.selectedViewController = viewControllers[tabBarIndex]

        if let destinationViewController = tabBarController.selectedViewController {
            tabBarController.tabBarController(tabBarController, didSelect: destinationViewController)
            currentPresentedController = tabBarController.selectedViewController

            if let topTabBarIndex = destination.topTabBar.index,
                let navigationItem = destinationViewController.navigationItem as? NavigationItem {
                tabBarController.tabBarController(tabBarController, didSelect: destinationViewController)
                tabBarCoordinator?.navigationItem(navigationItem, middleButtonPressedAtIndex: topTabBarIndex, ofTotal: 2)
                navigationItem.setIndicatorToButtonIndex(topTabBarIndex, animated: true)
                currentPresentedController = tabBarController.selectedViewController
            } else if
                let topTabBarIndex = destination.topTabBar.index,
                let universeController = destinationViewController as? MyUniverseViewController {
                    universeController.scrollToPageNumber(topTabBarIndex, animated: true)
                    universeController.navItem.setIndicatorToButtonIndex(topTabBarIndex)
                    pageTracker.track(universeController)
            } else if let topTabIndex = destination.topTabBar.index,
                let navController = destinationViewController as? UINavigationController,
                let pageController = navController.viewControllers[0] as? PageViewController,
                let navigationItem = pageController.navigationItem as? NavigationItem {
                tabBarController.tabBarController(tabBarController, didSelect: destinationViewController)
                pageController.setPageIndex(topTabIndex, animated: false)
                navigationItem.setIndicatorToButtonIndex(topTabIndex, animated: false)
                currentPresentedController = tabBarController.selectedViewController
            }
        }
        self.destination = nil
    }

    func presentSideBar(destination: AppCoordinator.Router.Destination?) -> SidebarCoordinator? {
        dismissCurrentPresentedControllers()
        guard
            let rootViewController = windowManager.rootViewController(atLevel: .normal),
            let services = services else { return nil }
        let coordinator = SidebarCoordinator(root: rootViewController,
                                             services: services,
                                             syncManager: syncManager,
                                             networkManager: networkManager,
                                             permissionsManager: permissionsManager,
                                             destination: destination)
        startChild(child: coordinator)
        currentPresentedController = coordinator.sideBarViewController
        currentPresentedNavigationController = coordinator.topTabBarController
        return coordinator
    }

    func presentSideBarWithDestination(_ destination: AppCoordinator.Router.Destination?) {
        guard let sidebarCoordinator = presentSideBar(destination: destination) else { return }
        sidebarCoordinator.didTapProfileCell(with: nil, in: sidebarCoordinator.sideBarViewController)
    }

    func navigateToCalendarSettings(_ destination: AppCoordinator.Router.Destination?) {
        navigateDownToTabBar {
            guard let sidebarCoordinator = self.presentSideBar(destination: destination) else { return }
            sidebarCoordinator.didTapCalendarCell(in: sidebarCoordinator.sideBarViewController)
        }
    }

    func presentNotificationsSettings() {
        AppDelegate.topViewController()?.showAlert(type: .changeNotifications, handler: {
            UIApplication.openAppSettings()
        })
    }

    func navigateToSiriSettings() {
        guard let services = services else { return }
        let configurator = SiriShortcutsConfigurator.make()
        let siriShortcutsViewController = SiriShortcutsViewController(configure: configurator, services: services)
        siriShortcutsViewController.hidesBottomBarWhenPushed = true
        AppDelegate.topViewController()?.pushToStart(childViewController: siriShortcutsViewController)
    }

    func navigateToNotificationsSettings() {
        guard
            let services = services,
            let viewModel = SettingsViewModel(services: services, settingsType: .notifications) else { return }
        let notificationsViewController = OldSettingsViewController(viewModel: viewModel,
                                                                    services: services,
                                                                    settingsType: .notifications,
                                                                    destination: nil)
        let leftBarButton = UIBarButtonItem(image: R.image.ic_close_white(),
                                            style: .plain,
                                            target: self,
                                            action: #selector(dismissCurrentPresentedControllers))
        let navigationController = UINavigationController(rootViewController: notificationsViewController)
        leftBarButton.tintColor = .white
        navigationController.navigationBar.applyDefaultStyle()
        notificationsViewController.navigationItem.leftBarButtonItem = leftBarButton
        windowManager.showPriority(navigationController, animated: true, completion: nil)
        currentPresentedNavigationController = navigationController
    }

    func presentCalendar(from rootController: UIViewController?) {
        guard let services = services else { return }
        let calendarsViewModel = SettingsCalendarListViewModel(services: services)
        let calendarsViewController = SettingsCalendarListViewController(viewModel: calendarsViewModel)
        if let rootController = rootController {
            calendarsViewController.hidesBottomBarWhenPushed = true
            rootController.pushToStart(childViewController: calendarsViewController)
        } else {
            let navigationController = UINavigationController(rootViewController: calendarsViewController)
            let leftBarButton = UIBarButtonItem(image: R.image.ic_close_white(),
                                                style: .plain,
                                                target: self,
                                                action: #selector(dismissCurrentPresentedControllers))
            leftBarButton.tintColor = .white
            navigationController.navigationBar.applyDefaultStyle()
            calendarsViewController.navigationItem.leftBarButtonItem = leftBarButton
            windowManager.showPriority(navigationController, animated: true, completion: nil)
            currentPresentedNavigationController = navigationController
        }
    }

    func presentLibrary() {
        guard let sidebarCoordinator = presentSideBar(destination: nil) else { return }
        sidebarCoordinator.didTapLibraryCell(in: sidebarCoordinator.sideBarViewController)
        currentPresentedController = sidebarCoordinator.sideBarViewController
    }

    func presentProfile(options: [LaunchOption: String?]) {
        guard let sidebarCoordinator = presentSideBar(destination: nil) else { return }
        sidebarCoordinator.didTapProfileCell(with: nil, in: sidebarCoordinator.sideBarViewController, options: options)
        currentPresentedController = sidebarCoordinator.sideBarViewController
    }

    func presentAddSensor(from rootController: UIViewController?) {
        let configurator = SensorConfigurator.make()
        let sensorViewController = SensorViewController(configure: configurator)
        if let rootController = rootController {
            sensorViewController.hidesBottomBarWhenPushed = true
            rootController.pushToStart(childViewController: sensorViewController)
        } else {
            let navController = UINavigationController(rootViewController: sensorViewController)
            let leftBarButton = UIBarButtonItem(image: R.image.ic_close_white(),
                                                style: .plain,
                                                target: self,
                                                action: #selector(dismissCurrentPresentedControllers))
            leftBarButton.tintColor = .white
            navController.navigationBar.applyDefaultStyle()
            sensorViewController.navigationItem.leftBarButtonItem = leftBarButton
            windowManager.showPriority(navController, animated: true, completion: nil)
            currentPresentedNavigationController = navController
        }
    }

    func presentToBeVision(articleItemController: ArticleItemViewController?,
                           options: [LaunchOption: String?]? = nil) {
        navigate(to: AppCoordinator.Router.Destination(tabBar: .tbv, topTabBar: .toBeVision))
    }

    func presentToBeVisionGenerator() {
        navigate(to: AppCoordinator.Router.Destination(tabBar: .tbv, topTabBar: .toBeVision))
        let visionViewController = ((currentPresentedController as? UINavigationController)?
            .viewControllers.first as? PageViewController)?
            .currentPage as? MyToBeVisionViewController
        visionViewController?.showVisionGenerator()
    }

    func presentWhatsHotArticle() {
        guard
            let services = services,
            let rootViewController = windowManager.rootViewController(atLevel: .normal),
            let content = services.contentService.whatsHotArticles().first else { return }
        tabBarCoordinator?.didTapItem(articleHeader: ArticleCollectionHeader(content: content), in: rootViewController)
        destination = nil
    }

    func presentWhatsHotArticle(with remoteID: Int) {
        guard
            let services = services,
            let rootViewController = windowManager.rootViewController(atLevel: .normal),
            let content = services.contentService.whatsHotArticle(with: remoteID).first else { return }
        tabBarCoordinator?.didTapItem(articleHeader: ArticleCollectionHeader(content: content), in: rootViewController)
        destination = nil
    }

    func presentPreparationCheckList(localID: String) {
        navigateDownToTabBar {
            if self.services != nil {
                self.tabBarCoordinator?.showPreparationCheckList(localID: localID)
            } else {
                self.checkListIDToPresent = localID
            }
        }
    }

    func navigateDownToTabBar(_ completion: (() -> Void)?) {
        dismissCurrentPresentedControllers()
        guard let topViewController = AppDelegate.topViewController() else { return }

        if topViewController is TabBarController {
            completion?()
        } else if let pageViewController = topViewController as? PageViewController {
            if pageViewController.tabBarController is TabBarController {
                completion?()
            } else {
                pageViewController.viewControllers?.forEach { (viewController: UIViewController) in
                    if windowManager.presentedViewController(atLevel: .priority) == viewController {
                        dismiss(viewController, level: .priority) {
                            self.navigateDownToTabBar(completion)
                        }
                    } else if windowManager.presentedViewController(atLevel: .normal) == viewController {
                        dismiss(viewController, level: .normal) {
                            self.navigateDownToTabBar(completion)
                        }
                    } else {
                        viewController.dismiss(animated: true) {
                            self.navigateDownToTabBar(completion)
                        }
                    }
                }
            }
        } else if (topViewController as? MyUniverseViewController)?.parent is TabBarController {
            completion?()
        } else if (topViewController as? LearnCategoryListViewController)?.parent is TabBarController {
            completion?()
        } else if (topViewController as? GuideViewController)?.parent is TabBarController {
            completion?()
        } else {
            topViewController.dismiss(animated: true) {
                self.navigateDownToTabBar(completion)
            }
        }
    }

    func presentPrepare(_ destination: AppCoordinator.Router.Destination) {
        navigate(to: destination)
        guard let chatViewController = tabBarCoordinator?.prepareChatViewController else { return }
        chatViewController.destination = destination
        chatViewController.routerDelegate = self
        calendarImportManager.importEvents()
    }

    func presentGuide() {
        navigate(to: AppCoordinator.Router.Destination(tabBar: .guide, topTabBar: .guide))
    }

    func presentMorningInterview(groupID: Int, date: ISODate) {
        do {
            if try realmProvider.realm()
                .objects(DailyPrepResultObject.self)
                .filter("isoDate == %@", date.string)
                .count == 0 {
                let configurator = MorningInterviewConfigurator.make(questionGroupID: groupID, date: date)
                guard
                    let navController = R.storyboard.morningInterviewViewController.instantiateInitialViewController(),
                    let interviewController = navController.viewControllers.first as? MorningInterviewViewController
                    else { return }
                configurator(interviewController)
                windowManager.showPriority(navController, animated: true, completion: nil)
                currentPresentedController = navController
                navController.navigationBar.applyDefaultStyle()
            } else {
                presentGuide()
            }
        } catch {
            log(error.localizedDescription, level: Logger.Level.error)
        }
    }

    func presentFeatureArticelContentItems(contentID: Int, guideItem: Guide.Item?, showHeader: Bool = true) {
        guard
            let rootViewController = windowManager.rootViewController(atLevel: .normal),
            let services = services,
            let content = services.contentService.contentCollection(id: contentID),
            let isWhatsHot = guideItem?.isWhatsHot,
            let coordinator = ArticleContentItemCoordinator(pageName: isWhatsHot ? .whatsHotArticle : .featureExplainer,
                                                            root: rootViewController,
                                                            services: services,
                                                            contentCollection: content,
                                                            articleHeader: showHeader ? ArticleCollectionHeader(content: content,
                                                                                                                displayDate: displayDate(guideItem: guideItem)) : nil,
                                                            topTabBarTitle: guideItem?.subtitle.uppercased(),
                                                            shouldPush: false,
                                                            guideItem: guideItem) else { return }
        startChild(child: coordinator)
        currentPresentedNavigationController = coordinator.topTabBarController
        currentPresentedController = coordinator.fullViewController

    }

    private func displayDate(guideItem: Guide.Item?) -> Date? {
        guard let content = guideItem?.content else { return nil }
        switch content {
        case .learningPlan(_, _, let displayDate): return displayDate
        default: return nil
        }
    }

    func presentFeatureArticelContentItems(contentID: Int, notificationID: Int) {
        if
            let rootViewController = windowManager.rootViewController(atLevel: .normal),
            let services = services,
            let content = services.contentService.contentCollection(id: contentID) {
                let displayDate = services.guideService.notificationItem(remoteID: notificationID)?.issueDate
                let guideItemContent = Guide.Item.Content.learningPlan(text: content.guideBody ?? "",
                                                                       strategiesCompleted: nil,
                                                                       displayDate: displayDate)
                let guideItem = Guide.Item(status: .done,
                                           title: content.guideTitle ?? "",
                                           content: guideItemContent,
                                           subtitle: content.guideBody ?? "",
                                           isDailyPrep: false,
                                           isLearningPlan: false,
                                           isWhatsHot: false,
                                           isToBeVision: false,
                                           isPreparation: false,
                                           link: URL(string: "qot://feature-explainer?contentID=\(contentID)"),
                                           featureLink: content.guideFeatureButton.link,
                                           featureButton: content.guideFeatureButton.title,
                                           identifier: "\(notificationID)",
                                           affectsTabBarBadge: false)
                if let coordinator = ArticleContentItemCoordinator(pageName: .featureExplainer,
                                                                   root: rootViewController,
                                                                   services: services,
                                                                   contentCollection: content,
                                                                   articleHeader: ArticleCollectionHeader(content: content),
                                                                   topTabBarTitle: content.guideType?.uppercased(),
                                                                   shouldPush: false,
                                                                   guideItem: guideItem) {
                    startChild(child: coordinator)
                    currentPresentedNavigationController = coordinator.topTabBarController
                    currentPresentedController = coordinator.fullViewController
                }
            }
    }

    func presentContentItemSettings(contentID: Int, controller: UIViewController?, pageName: PageName, topBarTitle: String? = nil) {
		guard
			let settingsViewController = controller,
			let services = services,
			let content = services.contentService.contentCollection(id: contentID),
			let coordinator = ArticleContentItemCoordinator(pageName: pageName,
															root: settingsViewController,
															services: services,
															contentCollection: content,
															articleHeader: nil,
															topTabBarTitle: nil,
                                                            topSmallTitle: topBarTitle,
															shouldPush: false,
															isSearch: false) else { return }
		startChild(child: coordinator)
		topTabBarController = coordinator.topTabBarController
		currentPresentedNavigationController = coordinator.topTabBarController
	}

    func presentContentItem(contentID: Int, searchViewController: SearchViewController?) {
        let isWhatsHot = services?.contentService.whatsHotArticles().filter { $0.remoteID.value == contentID }.count ?? 0 > 0
        guard
            let searchViewController = searchViewController,
            let services = services,
            let content = services.contentService.contentCollection(id: contentID),
            let coordinator = ArticleContentItemCoordinator(pageName: isWhatsHot ? .whatsHotArticle : .featureExplainer,
                                                            root: searchViewController,
                                                            services: services,
                                                            contentCollection: content,
                                                            articleHeader: ArticleCollectionHeader(content: content, displayDate: nil),
                                                            topTabBarTitle: nil,
                                                            shouldPush: false,
                                                            isSearch: true) else { return }
        startChild(child: coordinator)
        topTabBarController = coordinator.topTabBarController
        currentPresentedNavigationController = coordinator.topTabBarController
    }

    func presentLearnContentCollection(collectionID: String?) {
        guard
            let rootViewController = windowManager.rootViewController(atLevel: .normal),
            let services = services else { return }
        let coordinator = LearnContentListCoordinator(root: rootViewController,
                                                      transitioningDelegate: nil,
                                                      services: services,
                                                      eventTracker: eventTracker,
                                                      selectedCategoryIndex: 5,
                                                      originFrame: rootViewController.view.frame)
        coordinator.delegate = self
        startChild(child: coordinator)
    }

    func presentSigningVerificationView(code: String, email: String) {
        let topViewController = AppDelegate.topViewController()
        if let signingDigitController = topViewController as? SigningDigitViewController {
            signingDigitController.setup(code: code)
        }

        if let signingEmailController = topViewController as? SigningEmailViewController {
            pushSigningDigitController(code: code, email: email, root: signingEmailController)
        }

        if let signingInfoController = topViewController as? SigningInfoViewController {
            pushSigningDigitController(code: code, email: email, root: signingInfoController)
        }
    }

    func presentQRCodeURL(_ url: URL) {
        guard let urlString = services?.settingsService.string(key: url.absoluteString),
            let targetURL = URL(string: urlString) else {
            return
        }
        DispatchQueue.main.async {
            UIApplication.shared.open(targetURL, options: [:], completionHandler: nil)
        }
    }

    private func pushSigningDigitController(code: String, email: String, root: UIViewController) {
        let configurator = SigningDigitConfigurator.make(email: email, code: code)
        let controller = SigningDigitViewController(configure: configurator)
        root.pushToStart(childViewController: controller)
    }

    @objc func dismissCurrentPresentedControllers() {
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
            let chatViewController = viewController as? ChatViewController<PrepareAnswer>,
            let indexPath = destination?.chatSection.indexPath else { return }
        chatViewController.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}

extension AppCoordinator: IPadAdviceViewDelegate {

    func dismiss() {
        if let iPadAdvice = iPadAdviceView {
            UIView.animate(withDuration: Animation.duration_06, animations: {
                iPadAdvice.alpha = 0
            }, completion: { _ in
                iPadAdvice.removeFromSuperview()
                self.iPadAdviceCompletion?()
            })
        }
    }
}

//
//  AppCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import UserNotifications
import AirshipKit
import Buglife
import qot_dal

final class AppCoordinator {

    // MARK: - Static Properties

    static var permissionsManager: PermissionsManager?
    static var orientationManager: OrientationManager = OrientationManager()

    // MARK: - Properties

    private var isReadyToProcessURL = false

    var checkListIDToPresent: String?
    private let windowManager: WindowManager
    private let remoteNotificationHandler: RemoteNotificationHandler
    private let locationManager: LocationManager
    private var canProcessRemoteNotifications = false
    private var canProcessLocalNotifications = false
    private var onDismiss: (() -> Void)?
    private var iPadAdviceCompletion: (() -> Void)?
    private weak var topTabBarController: UINavigationController?
    private weak var currentPresentedController: UIViewController?
    private weak var currentPresentedNavigationController: UINavigationController?
    lazy var userLogoutNotificationHandler = NotificationHandler(name: .userLogout)
    lazy var automaticLogoutNotificationHandler = NotificationHandler(name: .automaticLogout)
    lazy var apnsDeviceTokenRegistrator = APNSDeviceTokenRegistrator()
    private lazy var permissionsManager: PermissionsManager = {
        let manager = PermissionsManager(delegate: self)
        return manager
    }()
    lazy var userLoggedIn: Bool = {
        return qot_dal.SessionService.main.getCurrentSession() != nil
    }()

    private lazy var iPadAdviceView: IPadAdviceView? = {
        let advice = UINib(resource: R.nib.iPadAdviceView).instantiate(withOwner: nil, options: nil).first as? IPadAdviceView
        // CHANGE ME
//        if
//            let title = IPadAdviceViewType.title.value(contentService: services?.contentService),
//            let body = IPadAdviceViewType.body.value(contentService: services?.contentService),
//            let buttonDismiss = IPadAdviceViewType.buttonDismiss.value(contentService: services?.contentService),
//            let buttonDoNotShow = IPadAdviceViewType.buttonDoNotShowAgain.value(contentService: services?.contentService) {
//                advice?.setupView(title: title,
//                                  body: body,
//                                  buttonTitleDismiss: buttonDismiss,
//                                  buttonTitleDoNotShow: buttonDoNotShow)
//        }
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
        remoteNotificationHandler.delegate = self
        userLogoutNotificationHandler.handler = { [weak self] (_: Notification) in
            self?.restart()
        }
        automaticLogoutNotificationHandler.handler = { [weak self] (_: Notification) in
            self?.restart()
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
        AppCoordinator.permissionsManager = self.permissionsManager
        self.setupBugLife()

        if qot_dal.SessionService.main.getCurrentSession() != nil {
            self.showApp()
            completion()
        } else {
            UserDefault.clearAllDataLogOut()
            self.showSigning()
        }
    }

    func restart() {
        logout()
        ExtensionsDataManager.didUserLogIn(false)
        showSigning()
    }

    func setupBugLife() {
        guard SessionService.main.getCurrentSession() != nil else { return }
        if qot_dal.SessionService.main.getCurrentSession()?.useremail?.lowercased().contains("@tignum.com") == true {
            Buglife.shared().start(withAPIKey: "fj62sZjDnl3g0dLuXJHUzAtt") // FIXME: obfuscate
            Buglife.shared().delegate = AppDelegate.current
            Buglife.shared().invocationOptions = [.shake]
        } else {
            Buglife.shared().delegate = nil
            Buglife.shared().invocationOptions = [.init(rawValue: 0)]
        }
    }

    func checkVersionIfNeeded() {
//        guard services?.userService.user()?.appUpdatePrompt == true else { return }
        // CHANGE ME
    }

    private func handleSetupError(error: Error) {
        log("Error setting up database: \(error)", level: .error)
        let message = "There was a problem initializing the app's data. Please restart the app and try again"
        self.showMajorAlert(type: .custom(title: "Error", message: message), handler: {
            exit(0)
        })
    }

    func showApp(with displayedScreen: CoachCollectionViewController.Pages? = .dailyBrief) {
        self.isReadyToProcessURL = true
        ExtensionsDataManager.didUserLogIn(true)
        ExtensionsDataManager().update(.toBeVision)
        add3DTouchShortcuts()
        // Show coach marks on first launch (of v3.0 app)
        let emails = UserDefault.didShowCoachMarks.object as? [String] ?? [String]()
        if let email = SessionService.main.getCurrentSession()?.useremail, !emails.contains(email) {
            showTrackChoice()
            return
        }

        guard let coachCollectionViewController = R.storyboard.main.coachCollectionViewController(),
            let rootViewController = R.storyboard.bottomNavigation().instantiateInitialViewController(),
            let rootNavigationController = rootViewController as? UINavigationController else {
                return
        }
        if let baseVC = rootNavigationController.viewControllers.first as? BaseRootViewController {
            baseVC.setContent(viewController: coachCollectionViewController)
        }

        self.windowManager.show(rootNavigationController, animated: true, completion: nil)

        self.registerRemoteNotifications()
        self.canProcessRemoteNotifications = true
        self.canProcessLocalNotifications = true
        self.remoteNotificationHandler.processOutstandingNotifications()
        AppDelegate.current.processOutstandingNotifications()
        AppDelegate.current.processOutstandingShortcuts()
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

    func showSubscriptionReminderIfNeeded() {
//        guard let user = services?.userService.user() else { return }
//        let lastShownDate = UserDefault.subscriptionInfoShow.object as? Date
//        if user.subscriptionExpired == true {
//            windowManager.showSubscriptionReminder(isExpired: true)
//        } else if user.subscriptionExpireSoon == true && (lastShownDate == nil || lastShownDate?.isToday == false) {
//            UserDefault.subscriptionInfoShow.setObject(Date())
//            windowManager.showSubscriptionReminder(isExpired: false)
//        }
        // CHANGE ME
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

    func showTrackChoice() {
        guard let controller = R.storyboard.trackSelection.trackSelectionViewController() else { return }

        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isHidden = true
        navigationController.navigationBar.applyDefaultStyle()
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .overFullScreen

        let configurator = TrackSelectionConfigurator.make()
        configurator(controller, .login)
        UIApplication.shared.delegate?.window??.rootViewController?.present(navigationController, animated: false, completion: nil)
    }

    func showSigning() {
        qot_dal.ContentService.main.getContentCategory(.Onboarding_3_0) { (contentCategory) in
            let landingConfigurator = OnboardingLandingPageConfigurator.make()
            let landingController = OnboardingLandingPageViewController()
            landingConfigurator(landingController, contentCategory)

            let navigationController = UINavigationController(rootViewController: landingController)
            navigationController.navigationBar.isHidden = true
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
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
        UIApplication.shared.shortcutItems?.removeAll()
    }

    func didLogin() {
        showApp()
    }

    func add3DTouchShortcuts() {
        UIApplication.shared.shortcutItems = []
        let whatsHot = URLScheme.latestWhatsHotArticle
        UIApplication.shared.shortcutItems?.append(
            UIMutableApplicationShortcutItem(type: whatsHot.rawValue,
                                             localizedTitle: R.string.localized.shortcutItemTitleWhatsHot(),
                                             localizedSubtitle: nil,
                                             icon: UIApplicationShortcutIcon(templateImageName: "shortcutItem-whats-hot-article"),
                                             userInfo: ["link": whatsHot.launchPathWithParameterValue("")]))
        let tools = URLScheme.tools
        UIApplication.shared.shortcutItems?.append(
            UIMutableApplicationShortcutItem(type: tools.rawValue,
                                             localizedTitle: R.string.localized.shortcutItemTitleLibrary(),
                                             localizedSubtitle: nil,
                                             icon: UIApplicationShortcutIcon(templateImageName: "shortcutItem-tools"),
                                             userInfo: ["link": tools.launchPathWithParameterValue("")]))
        let myData = URLScheme.myData
        UIApplication.shared.shortcutItems?.append(
            UIMutableApplicationShortcutItem(type: myData.rawValue,
                                             localizedTitle: R.string.localized.shortcutItemTitleMeUniverse(),
                                             localizedSubtitle: nil,
                                             icon: UIApplicationShortcutIcon(templateImageName: "shortcutItem-my-data"),
                                             userInfo: ["link": myData.launchPathWithParameterValue("")]))
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
//            services?.userService.setMyToBeVisionReminder(true)
            // REMOVE ME
            break
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
        manager.fetchDescriptions { (descriptions) in
            var devicePermissions = [QDMDevicePermission]()
            for permissionIdentifer in descriptions.keys {
                guard let statusString = descriptions[permissionIdentifer],
                    let status = QotDevicePermissionState(rawValue: statusString) else { continue }
                var devicePermission = QDMDevicePermission()
                devicePermission.permissionState = status
                switch permissionIdentifer {
                case .calendar:
                    devicePermission.feature = .calendar
                case .notifications:
                    devicePermission.feature = .notifcations
                case .location:
                    devicePermission.feature = .location
                case .photos:
                    devicePermission.feature = .photos
                case .camera:
                    devicePermission.feature = .camera
                }

                devicePermissions.append(devicePermission)
            }
            guard !devicePermissions.isEmpty else { return }
            qot_dal.QOTService.main.updateDevicePermissions(permissions: devicePermissions)
        }
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

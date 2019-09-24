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

    private var reachability = QOTReachability()
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didFinishSynchronization(_:)),
                                               name: .didFinishSynchronization, object: nil)
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
        self.setupBugLife()

        if qot_dal.SessionService.main.getCurrentSession() != nil {
            self.showApp()
            completion()
        } else {
            UserDefault.clearAllDataLogOut()
            self.showSigning()
        }
        DispatchQueue.main.async {
            self.setupPermissionsManager()
        }
    }

    func setupPermissionsManager() {
        AppCoordinator.permissionsManager = self.permissionsManager
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

        // set invalid bucket name with GUIDE_TRACK if user selected fast track
        // DailyBriefService.main.setInvalidBucketNames([.GUIDE_TRACK])

        guard let coachCollectionViewController = R.storyboard.main.coachCollectionViewController(),
            let naviController = R.storyboard.bottomNavigation().instantiateInitialViewController() as? UINavigationController,
            let baseRootViewController = naviController.viewControllers.first as? BaseRootViewController else {
                return
        }
        self.windowManager.show(naviController, animated: true, completion: nil)
        DispatchQueue.main.async {
            baseRootViewController.setContent(viewController: coachCollectionViewController)
            self.canProcessRemoteNotifications = true
            self.canProcessLocalNotifications = true
        }
    }

    func isReadyToOpenURL() -> Bool {
        return isReadyToProcessURL
    }
}

// MARK: - private

private extension AppCoordinator {

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
        guard let controller = R.storyboard.trackSelection.trackSelectionViewController(),
            let navigationController = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController,
            let baseController = navigationController.viewControllers.first as? BaseRootViewController else { return }
        let configurator = TrackSelectionConfigurator.make()
        configurator(controller, .login)
        baseController.setContent(viewController: controller)
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

// MARK: Synchonization Update

extension AppCoordinator {

    @objc func didFinishSynchronization(_ notification: Notification) {
        let dataTypes: [SyncDataType] = [.CONTENT_COLLECTION, .DAILY_CHECK_IN_RESULT, .MY_TO_BE_VISION, .PREPARATION, .USER]
        guard let syncResult = notification.object as? SyncResultContext,
            dataTypes.contains(obj: syncResult.dataType) else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            switch syncResult.dataType {
            case .USER:
                UserService.main.getUserData({ (user) in
                    guard var user = user else { return }
                    if user.timeZone != TimeZone.hoursFromGMT {
                        user.timeZone = TimeZone.hoursFromGMT
                        UserService.main.updateUserData(user, { (_) in
                            /* */
                        })
                    }
                })
            case .MY_TO_BE_VISION:
                guard syncResult.hasUpdatedContent else { return }
                UserService.main.getMyToBeVision({ (vision, initiated, error) in
                    guard error == nil, initiated == true, let vision = vision else { return }
                    let data = ExtensionModel.ToBeVision(headline: vision.headline, text: vision.text, imageURL: vision.profileImageResource?.url())
                    ExtensionUserDefaults.set(data, for: .toBeVision)
                })
            case .DAILY_CHECK_IN_RESULT:
                guard syncResult.hasUpdatedContent else { return }
                MyDataService.main.getDailyCheckInResults(from: Date().beginingOfDate(), to: nil, { (results, initiated, error) in
                    guard error == nil, initiated == true, let result = results?.first else { return }

                    let data = ExtensionModel.DailyPrep(loadValue: Float(result.load ?? 0),
                                                        recoveryValue: Float(result.impactReadiness ?? 0),
                                                        feedback: result.feedback, displayDate: Date())
                    ExtensionUserDefaults.set(data, for: .dailyPrep)
                })
            case .CONTENT_COLLECTION:
                guard syncResult.hasUpdatedContent else { return }
                ContentService.main.getContentCollectionBySection(.WhatsHot, { (items) in
                    guard let latest = items?.first else { return }
                    let item = ArticleCollectionViewData.Item(author: latest.author ?? "",
                                                              title: latest.contentCategoryTitle ?? "",
                                                              description: latest.title,
                                                              date: latest.publishedDate ?? Date(),
                                                              duration: latest.durationString,
                                                              articleDate: latest.publishedDate ?? Date(),
                                                              sortOrder: "0",
                                                              previewImageURL: URL(string: latest.thumbnailURLString  ?? ""),
                                                              contentCollectionID: latest.remoteID ?? 0,
                                                              newArticle: true,
                                                              shareableLink: latest.shareableLink)
                    ExtensionUserDefaults.set(ArticleCollectionViewData(items: [item]), for: .whatsHot)
                })
            case .PREPARATION:
                if syncResult.syncRequestType == .DOWN_SYNC {
                    UserService.main.getUserPreparationsWithMissingEvent(from: Date().beginingOfDate(), { (preps, initalized, error) in
                        guard let preps = preps, preps.count > 0 else { return }
                        log("preps with missing events : \(preps)")
                        let configurator = PreparationWithMissingEventConfigurator.make(preps)
                        let viewController = PreparationWithMissingEventViewController.init(configure: configurator)
                        baseRootViewController?.present(viewController, animated: true, completion: nil)
                    })
                }
            default: break
            }
        }
    }
}

//
//  AppCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import UserNotifications
import Airship
import Buglife
import qot_dal

final class AppCoordinator {

    // MARK: - Static Properties
    static var permissionsManager: PermissionsManager?
    static var orientationManager: OrientationManager = OrientationManager()

    // MARK: - Properties
    private var isReadyToProcessURL = false
    private let remoteNotificationHandler: RemoteNotificationHandler
    private var onDismiss: (() -> Void)?
    private weak var topTabBarController: UINavigationController?
    private weak var currentPresentedController: UIViewController?
    private weak var currentPresentedNavigationController: UINavigationController?
    lazy var userLogoutNotificationHandler = NotificationHandler(name: .userLogout)
    lazy var automaticLogoutNotificationHandler = NotificationHandler(name: .automaticLogout)
    lazy var apnsDeviceTokenRegistrator = APNSDeviceTokenRegistrator()
    private lazy var permissionsManager = PermissionsManager(delegate: self)

    // MARK: - Life Cycle
    init(remoteNotificationHandler: RemoteNotificationHandler) {
        self.remoteNotificationHandler = remoteNotificationHandler
        userLogoutNotificationHandler.handler = { [weak self] (_: Notification) in
            self?.restart()
        }
        automaticLogoutNotificationHandler.handler = { [weak self] (_: Notification) in
            self?.restart()
        }
        _ = NotificationCenter.default.addObserver(forName: .didFinishSynchronization,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.didFinishSynchronization(notification)
        }
        _ = NotificationCenter.default.addObserver(forName: .needToCheckDeletedEventForPreparation,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.checkDeletedEventForPreparation(notification)
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
        self.setupBugLife()

        if SessionService.main.getCurrentSession() != nil {
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
        permissionManager(permissionsManager, didUpdatePermissions: permissionsManager.allPermissions)
    }

    func restart() {
        logout()
        ExtensionsDataManager.didUserLogIn(false)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.showSigning()
        }
    }

    func setupBugLife() {
        if SessionService.main.getCurrentSession()?.useremail?.lowercased().contains("@tignum.com") == true {
            Buglife.shared().start(withAPIKey: "fj62sZjDnl3g0dLuXJHUzAtt") // FIXME: obfuscate
            Buglife.shared().delegate = AppDelegate.current
            Buglife.shared().invocationOptions = [.shake, .screenshot]
        } else {
            Buglife.shared().delegate = nil
            Buglife.shared().invocationOptions = []
        }
    }

    func checkVersionIfNeeded() {
        //guard services?.userService.user()?.appUpdatePrompt == true else { return }
        // TODO: We need to handle response from "/personal/p/qot/qotversionexpirydate"
    }

    func showApp(with displayedScreen: CoachCollectionViewController.Page? = .dailyBrief) {
        ExtensionsDataManager.didUserLogIn(true)
        ExtensionsDataManager().update(.toBeVision)
        ExtensionsDataManager().update(.teams)
        add3DTouchShortcuts()
        setupBugLife()
        guard let coachCollectionViewController = R.storyboard.main.coachCollectionViewController(),
            let naviController = R.storyboard.bottomNavigation().instantiateInitialViewController() as? UINavigationController,
            let baseRootViewController = naviController.viewControllers.first as? BaseRootViewController else {
                return
        }

        self.setRootViewController(naviController,
                                   transitionStyle: .curveEaseIn,
                                   duration: 0,
                                   animated: false) {
            DispatchQueue.main.async {
                // Show coach marks on first launch (of v3.0 app)
                let emails = UserDefault.didShowCoachMarks.object as? [String] ?? [String]()
                if let email = SessionService.main.getCurrentSession()?.useremail, !emails.contains(email) {
                    self.showCoachMarks()
                } else {
                    baseRootViewController.setContent(viewController: coachCollectionViewController)
                    self.isReadyToProcessURL = true
                }
                self.showSubscriptionReminderIfNeeded()
            }
        }
    }

    private func setRootViewController(_ viewController: UIViewController,
                                       transitionStyle: UIView.AnimationOptions,
                                       duration: TimeInterval,
                                       animated: Bool,
                                       completion: (() -> Void)?) {
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window,
            let rootViewController = window.rootViewController else {
            assertionFailure("rootViewController should not be nil")
            return
        }
        window.makeKeyAndVisible()
        // FIXME: Setting the frame here is necessary to avoid an unintended animation in some situations.
        // Not sure why this is happening. We should investigate.
        viewController.view.frame = rootViewController.view.bounds
        viewController.view.layoutIfNeeded()
        UIView.transition(with: window, duration: duration, options: transitionStyle, animations: {
            window.rootViewController = viewController
        }, completion: { _ in
            completion?()
        })
    }

    func isReadyToOpenURL() -> Bool {
        return isReadyToProcessURL
    }
}

// MARK: - private
private extension AppCoordinator {
    func showSubscriptionReminderIfNeeded() {
        UserService.main.getUserData({ [weak self] (userData) in
            let lastShownDate = UserDefault.subscriptionInfoShow.object as? Date
            if userData?.subscriptionExpired == true {
                // CHANGE ME https://tignum.atlassian.net/browse/QOT-2628
                self?.showSubscriptionReminder(isExpired: true)
                UserDefault.subscriptionInfoShow.clearObject()
            } else if userData?.subscriptionExpireSoon == true &&
                (lastShownDate == nil || lastShownDate?.isToday == false) {
                UserDefault.subscriptionInfoShow.setObject(Date())
                // CHANGE ME https://tignum.atlassian.net/browse/QOT-2628
                self?.showSubscriptionReminder(isExpired: false)
            } else if userData?.subscriptionExpired != true, userData?.subscriptionExpireSoon != true,
                let topViewController = AppDelegate.topViewController() as? PaymentReminderViewController {
                topViewController.dismiss(animated: true, completion: nil)
            }
        })
    }

    func showSubscriptionReminder(isExpired: Bool) {
        let configurator = PaymentReminderConfigurator.make(isExpired: isExpired)
        let controller = PaymentReminderViewController(configure: configurator)
        let topViewController = AppDelegate.topViewController()
        if let vc = topViewController as? PaymentReminderViewController,
            vc.interactor?.isExpired != isExpired {
            let presenterVC = topViewController?.presentingViewController
            presenterVC?.dismiss(animated: false, completion: {
                presenterVC?.present(controller, animated: false, completion: {
                    /* DO NOTHING */
                })
            })
        } else {
            topViewController?.present(controller, animated: false, completion: {
                /* DO NOTHING */
            })
        }
    }
}

// MARK: - Navigation
extension AppCoordinator {
    func showCoachMarks() {
        guard let controller = R.storyboard.coachMark.coachMarksViewController(),
            let navigationController = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController,
            let baseController = navigationController.viewControllers.first as? BaseRootViewController else { return }
        let configurator = CoachMarksConfigurator.make()
        configurator(controller)
        baseController.setContent(viewController: controller)
    }

    func showSigning() {
        let signinInfoConfigurator = SigningInfoConfigurator.make()
        let signinInfoController = SigningInfoViewController()
        signinInfoConfigurator(signinInfoController)

        guard let navigationController = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController,
        let baseController = navigationController.viewControllers.first as? BaseRootViewController else { return }

        self.setRootViewController(navigationController, transitionStyle: .curveEaseIn, duration: 0, animated: false) {
            let navigationController = UINavigationController(rootViewController: signinInfoController)
            navigationController.navigationBar.isHidden = true
            navigationController.modalTransitionStyle = .crossDissolve
            navigationController.modalPresentationStyle = .overFullScreen
            baseController.setContent(viewController: navigationController)
        }
    }

    func logout() {
        permissionsManager.reset()
        setupBugLife()
        UserDefault.clearAllDataLogOut()
        isReadyToProcessURL = false
        HorizontalHeaderView.selectedTeamId = ""
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
        UIApplication.shared.shortcutItems?.removeAll()
    }

    func didLogin() {
        if SessionService.main.getCurrentSession() != nil {
            importHealthKitDataIfAuthorized()
            importCalendarEventsIfAuthorized()
        }
        showApp()
    }

    func add3DTouchShortcuts() {
        let whatsHot = URLScheme.latestWhatsHotArticle
        let tools = URLScheme.tools
        let myData = URLScheme.myData
        let whatsHotItem = UIMutableApplicationShortcutItem(type: whatsHot.rawValue,
                                                            localizedTitle: AppTextService.get(.generic_long_press_shortcut_title_wh_article),
                                                            localizedSubtitle: nil,
                                                            icon: UIApplicationShortcutIcon(templateImageName: "shortcutItem-whats-hot-article"),
                                                            userInfo: [:])
        let toolsItem = UIMutableApplicationShortcutItem(type: tools.rawValue,
                                                         localizedTitle: AppTextService.get(.generic_long_press_shortcut_title_tools),
                                                         localizedSubtitle: nil,
                                                         icon: UIApplicationShortcutIcon(templateImageName: "shortcutItem-tools"),
                                                         userInfo: [:])
        let myDataItem = UIMutableApplicationShortcutItem(type: myData.rawValue,
                                                          localizedTitle: AppTextService.get(.generic_long_press_shortcut_title_review_my_data),
                                                          localizedSubtitle: nil,
                                                          icon: UIApplicationShortcutIcon(templateImageName: "shortcutItem-my-data"),
                                                          userInfo: [:])

        UIApplication.shared.shortcutItems = [whatsHotItem, toolsItem, myDataItem]
    }
}

// MARK: - Handle incomming RemoteNotification
extension AppCoordinator {
    func handleIncommingNotificationDeepLinkURLInBackground(identifier: String,
                                                            url: URL, completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let host = url.host, let scheme = URLScheme(rawValue: host) else {
            completionHandler(.noData)
            return
        }
        log("handleIncommingNotificationDeepLinkURL[\(scheme)]: \(url)", level: .info)
        NotificationService.main.reportReceivedPushNotification(identifier: nil, internalNotificationIdentifier: identifier, link: url.absoluteString) { (error) in
            completionHandler(.noData)
        }
        // TODO: handle silent push notification... ie. Sync Content or import Calendar Events .. and so on
    }

    func handleIncommingNotificationDeepLinkURL(identifier: String,
                                                url: URL, completionHandler: @escaping () -> Void) {
        guard let host = url.host, let scheme = URLScheme(rawValue: host) else {
            completionHandler()
            return
        }
        log("handleIncommingNotificationDeepLinkURL[\(scheme)]: \(url)", level: .info)
        NotificationService.main.reportReceivedPushNotification(identifier: nil, internalNotificationIdentifier: identifier, link: url.absoluteString) { (error) in
            completionHandler()
        }
        // TODO: handle silent push notification... ie. Sync Content or import Calendar Events .. and so on
    }

    func handlePushNotificationResponse(identifier: String, completionHandler: @escaping () -> Void) {
        NotificationService.main.reportSelectedNotification(internalNotificationIdentifier: identifier) { (_) in
            completionHandler()
        }
    }
}

// MARK: - PermissionDelegate
extension AppCoordinator: PermissionManagerDelegate {
    func permissionManager(_ manager: PermissionsManager,
                            didUpdatePermissions permissions: [PermissionsManager.Permission]) {
        var devicePermissions = [QDMDevicePermission]()
        for permission in manager.allPermissions {
            var devicePermission = QDMDevicePermission()
            switch manager.currentStatusFor(for: permission.identifier) {
            case .granted:
                devicePermission.permissionState = .authorized
            case .grantedWhileInForeground:
                devicePermission.permissionState = .authorizedOnForeground
            case .denied:
                devicePermission.permissionState = .denied
            case .notDetermined:
                devicePermission.permissionState = .notDetermined
            case .restricted:
                devicePermission.permissionState = .restricted
            }
            switch permission.identifier {
            case .calendar:
                devicePermission.feature = .calendar
            case .notifications:
                devicePermission.feature = .notifications
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
        QOTService.main.updateDevicePermissions(permissions: devicePermissions)
    }
}

// MARK: Synchonization Update
extension AppCoordinator {
    @objc func didFinishSynchronization(_ notification: Notification) {
        let dataTypes: [SyncDataType] = [.CONTENT_COLLECTION, .DAILY_CHECK_IN_RESULT, .MY_TO_BE_VISION, .USER]
        guard let syncResult = notification.object as? SyncResultContext,
            syncResult.hasUpdatedContent,
            dataTypes.contains(obj: syncResult.dataType) else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            switch syncResult.dataType {
            case .USER:
                guard syncResult.syncRequestType == .DOWN_SYNC else { break }
                self.handleUserDataDownSync()
            case .MY_TO_BE_VISION:
                self.handleMyToBeVisionDownSync()
            case .DAILY_CHECK_IN_RESULT:
                self.handleDailyCheckInResultDownSync()
            case .CONTENT_COLLECTION:
                self.handleContentDownSync()
            default: break
            }
        }
    }

    @objc func checkDeletedEventForPreparation(_ notification: Notification) {
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else { return }
        self.handlePreparationDownSync()
    }

    func handlePreparationDownSync() {
        guard CalendarService.main.isCalendarInitialized() else {
            return
        }
        UserService.main.getUserPreparationsWithMissingEvent(from: Date.beginingOfDay(), { (preps, initalized, error) in
            guard let preparations = preps, preparations.count > 0 else { return }
            log("preps with missing events : \(preparations)", level: .debug)
            let configurator = PreparationWithMissingEventConfigurator.make(preparations)
            let viewController = PreparationWithMissingEventViewController.init(configure: configurator)
            baseRootViewController?.present(viewController, animated: true, completion: nil)
        })
    }

    func handleContentDownSync() {
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
    }

    func handleDailyCheckInResultDownSync() {
        MyDataService.main.getDailyCheckInResults(from: Date().beginingOfDate(), to: nil, { (results, initiated, error) in
            guard error == nil, initiated == true, let result = results?.first else { return }

            let data = ExtensionModel.DailyPrep(loadValue: Float(result.load ?? 0),
                                                recoveryValue: Float(result.impactReadiness ?? 0),
                                                feedback: result.feedback, displayDate: Date())
            ExtensionUserDefaults.set(data, for: .dailyPrep)
        })
    }

    func handleMyToBeVisionDownSync() {
        UserService.main.getMyToBeVision({ (vision, initiated, error) in
            guard error == nil, initiated == true, let vision = vision else { return }
            let data = ExtensionModel.ToBeVision(headline: vision.headline, text: vision.text, imageURL: vision.profileImageResource?.url())
            ExtensionUserDefaults.set(data, for: .toBeVision)
        })
    }

    func handleUserDataDownSync() {
        UserService.main.getUserData({ (user) in
            guard var user = user else { return }
            if user.timeZone != TimeZone.hoursFromGMT {
                user.timeZone = TimeZone.hoursFromGMT
                UserService.main.updateUserData(user, { (_) in
                    /* */
                })
            }
        })
        showSubscriptionReminderIfNeeded()
    }
}

// MARK: - Calendar event import
extension AppCoordinator {
    func importCalendarEventsIfAuthorized() {
        let authStatus = EKEventStore.authorizationStatus(for: .event)
        switch authStatus {
        case .authorized:
            CalendarService.main.importCalendarEvents()
        default:
            return
        }
    }
}

// MARK: - HealthKit Import Data
extension AppCoordinator {
    func importHealthKitDataIfAuthorized() {
        if HealthService.main.isHealthDataAvailable() == true {
            HealthService.main.importHealthKitSleepAnalysisData()
        }
    }
}

//
//  AppDelegate.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Airship
import CoreLocation
import Buglife
import Kingfisher
import SVProgressHUD
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import qot_dal

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    var window: UIWindow?
    var backgroundCompletionHandler: (() -> Void)?

    lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(remoteNotificationHandler: remoteNotificationHandler)
    }()
    lazy var remoteNotificationHandler: RemoteNotificationHandler = {
        return RemoteNotificationHandler(launchHandler: launchHandler)
    }()
    lazy var launchHandler: LaunchHandler = {
        let launchHandler = LaunchHandler()
        return launchHandler
    }()
    static var current: AppDelegate {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        return app
    }

    private var isRunning = false

    // MARK: - Life Cycle

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if SessionService.main.getCurrentSession() != nil {
            appCoordinator.importHealthKitDataIfAuthorized()
            appCoordinator.importCalendarEventsIfAuthorized()
        }

        #if UNIT_TEST
            Logger.shared.setup()
        #else
            if isRunning {
                return true
            }
            isRunning = true
            _ = UserNotificationsManager.main
            setupProgressHud()
            swizzleUIViewController()
            swizzleUINavigationController()
            window = UIWindow(frame: UIScreen.main.bounds)
            if let url = launchOptions?[.url] as? URL {
                RestartHelper.setRestartURL(url)
            }
            appCoordinator.start(completion: { /* DONE */})

            incomingLocationEvent(launchOptions: launchOptions)
            setupUAirship()
            setupAppCenter()
            setupKingfisherCache()
            QOTService.main.reportAppStatus(.start)
            sendSiriEventsIfNeeded()
            UNUserNotificationCenter.current().delegate = self
        #endif //#if UNIT_TEST
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        #if UNIT_TEST
            return
        #else
            application.applicationIconBadgeNumber = 0
            appCoordinator.checkVersionIfNeeded()
        #endif //#if UNIT_TEST
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        #if UNIT_TEST
        return
        #else
            QOTService.main.reportAppStatus(.background)
        #endif //#if UNIT_TEST
    }

    func applicationWillTerminate(_ application: UIApplication) {
        #if UNIT_TEST
            return
        #else
            QOTService.main.reportAppStatus(.termination)
        #endif
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        #if UNIT_TEST
            return
        #else
            ExternalLinkImporter.main.importLink()
            appCoordinator.checkVersionIfNeeded()
            sendSiriEventsIfNeeded()
            QOTService.main.reportAppStatus(.didBecomeActive)
            if SessionService.main.getCurrentSession() != nil {
                appCoordinator.importHealthKitDataIfAuthorized()
                appCoordinator.importCalendarEventsIfAuthorized()
                NotificationCenter.default.post(name: .requestSynchronization, object: nil)
            }
        #endif //#if UNIT_TEST
    }

    func applicationWillResignActive(_ application: UIApplication) {
        #if UNIT_TEST
            return
        #else
            requestSynchronization(.PAGE_TRACK, .UP_SYNC)
            requestSynchronization(.USER_EVENT_TRACK, .UP_SYNC)
            QOTService.main.reportAppStatus(.willResignActive)
        #endif //#if UNIT_TEST
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if launchHandler.canLaunch(url: url) == true && URLScheme.isLaunchableHost(host: url.host) == true {
            launchHandler.process(url: url)
        }

        return launchHandler.canLaunch(url: url)
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return handleActivity(userActivity: userActivity)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToken = UAUtils.deviceTokenString(fromDeviceToken: deviceToken)
        appCoordinator.apnsDeviceTokenRegistrator.registerDeviceToken(deviceToken)
        UserNotificationsManager.main.scheduleNotifications()
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log("Did Fail To Register For Remote Notifications With Error: \(error)", level: .error)
    }

    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        handleShortcut(shortcutItem: shortcutItem)
    }

    func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession identifier: String,
                     completionHandler: @escaping () -> Void) {
        backgroundCompletionHandler = completionHandler
    }

    func handleShortcut(shortcutItem: UIApplicationShortcutItem) {
        guard let type = URLScheme(rawValue: shortcutItem.type) else { return }
        switch type {
        case .latestWhatsHotArticle, .tools, .myData:
            guard let link = type.launchURLWithParameterValue(String.empty) else { return }
            launchHandler.process(url: link)
        default: return
        }
    }

    //Interface Orientation
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppCoordinator.orientationManager.supportedOrientations
    }
}

// MARK: - private

private extension AppDelegate {
    func incomingLocationEvent(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let locationEvent = launchOptions?[UIApplication.LaunchOptionsKey.location] as? NSNumber else { return }
        if locationEvent.boolValue == true {
            // needs a restart at this point
            QOTService.main.reportDeviceInfo()
        }
    }

    func setupUAirship() {
        guard let path = Bundle.main.path(forResource: "AirshipConfig", ofType: "plist") else { return }
        let config = UAConfig(contentsOfFile: path)
        config.developmentLogLevel = .error
        UAirship.takeOff(config)
        UAirship.push()?.pushNotificationDelegate = remoteNotificationHandler
        UAirship.push()?.updateRegistration()
        UAirship.shared()?.analytics.isEnabled = true
        UserService.main.getUserData { (user) in
            if let userId = user?.remoteID {
                UAirship.channel()?.addTags(["\(userId)"])
                UAirship.channel()?.updateRegistration()
                let channelID = UAirship.channel().identifier
                log("UAirship Application Channel ID: \(String(describing: channelID))", level: .info)
            }
        }
    }

    func setupAppCenter() {
        if let appCenterID = Bundle.main.object(forInfoDictionaryKey: "APP_CENTER_ID") as? String {
            AppCenter.start(withAppSecret: appCenterID, services: [Analytics.self, Crashes.self])
        }
    }

    func setupKingfisherCache() {
        let cache = ImageCache.default
        cache.memoryStorage.config.expiration = .days(1)
        cache.diskStorage.config.expiration = .days(30)
        KingfisherManager.shared.downloader.downloadTimeout = 60
    }
}

// MARK: - Current top view controller

extension AppDelegate {

    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {

    func handleNotification(notification: UNNotification) {
        log("handle local notification: \(notification)")
        var link: URL?
        if let linkString = notification.request.content.userInfo["link"] as? String {
            link = URL(string: linkString)
        } else if let urlString = notification.request.content.userInfo["url"] as? String {
            link = URL(string: urlString)
        } else if let urlString = notification.request.content.userInfo["^d"] as? String {
            link = URL(string: urlString)
        } else {
            let stringValues = notification.request.content.userInfo.values.filter { ($0 is String) } as? [String]
            let userInfoUrlString = stringValues?.filter {
                $0.contains("qot://") || $0.contains("tignumx://")
            }.first
            if let urlString = userInfoUrlString {
                link = URL(string: urlString)
            }
        }
        guard let notificationLink = link, launchHandler.canLaunch(url: notificationLink) == true else { return }
        launchHandler.process(url: notificationLink)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        log("QOT will present notification:: \(notification)")
        NotificationService.main.reportPresentedNotification(internalNotificationIdentifier: notification.request.identifier) { (_) in
            completionHandler([.alert, .sound])
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotification(notification: response.notification)
        NotificationService.main.reportSelectedNotification(internalNotificationIdentifier: response.notification.request.identifier) { (_) in
            completionHandler()
        }
    }
}

// MARK: - NSUserActivity

extension AppDelegate {

    private func handleActivity(userActivity: NSUserActivity) -> Bool {
        var launchURL: URL?
        switch userActivity.activityType {
        case NSUserActivity.ActivityType.toBeVisionGenerator.rawValue,
             NSUserActivity.ActivityType.toBeVision.rawValue:
            launchURL = URLScheme.toBeVision.launchURLWithParameterValue(String.empty)
        case NSUserActivity.ActivityType.whatsHotArticle.rawValue:
            launchURL = URLScheme.latestWhatsHotArticle.launchURLWithParameterValue(String.empty)
        case NSUserActivity.ActivityType.whatsHotArticlesList.rawValue:
            launchURL = URLScheme.knowFeed.launchURLWithParameterValue(String.empty)
        case NSUserActivity.ActivityType.dailyPrep.rawValue:
            launchURL = URLScheme.dailyCheckIn.launchURLWithParameterValue(String.empty)
        default:
            break
        }
        if let url = launchURL {
            UIApplication.shared.open(url, options: [:]) { (_) in }
            return true
        }
        return false
    }
}

// MARK: - AppEvents/PageTracking

extension AppDelegate {

    func sendSiriEventsIfNeeded() {
        if let events: SiriEventsModel = ExtensionUserDefaults.object(for: .siri, key: .siriAppEvents) {
            events.events.forEach {
                var userEventTrack = QDMUserEventTracking()
                userEventTrack.action = .SIRI_READ
                userEventTrack.date = $0.date
                switch $0.key {
                case ExtensionUserDefaults.toBeVision.rawValue:
                    userEventTrack.name = .SIRI_TO_BE_VISION
                    NotificationCenter.default.post(name: .reportUserEvent, object: userEventTrack)
                case ExtensionUserDefaults.whatsHot.rawValue:
                    userEventTrack.name = .SIRI_WHATS_HOT
                    NotificationCenter.default.post(name: .reportUserEvent, object: userEventTrack)
                case ExtensionUserDefaults.upcomingEvents.rawValue:
                    userEventTrack.name = .SIRI_PREPARATION_EVENT
                    NotificationCenter.default.post(name: .reportUserEvent, object: userEventTrack)
                case ExtensionUserDefaults.dailyPrep.rawValue:
                    userEventTrack.name = .SIRI_DAILY_CHECK_IN
                    NotificationCenter.default.post(name: .reportUserEvent, object: userEventTrack)
                default: break
                }
            }
            ExtensionUserDefaults.siriAppEvents.clearWidgetObject()
        }
    }
}

// MARK: - SVProgressHUD

extension AppDelegate {
    private func setupProgressHud() {
        SVProgressHUD.setGraceTimeInterval(0.2)
        SVProgressHUD.setMinimumDismissTimeInterval(0.5)
        SVProgressHUD.setDefaultStyle(.dark)
    }
}

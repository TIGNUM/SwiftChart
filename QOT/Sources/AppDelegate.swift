//
//  AppDelegate.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import AirshipKit
import CoreLocation
import Buglife
import Kingfisher
import SVProgressHUD
import qot_dal

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    var window: UIWindow?
    private var unhandledShortCuts = [UIApplicationShortcutItem]()
    lazy var locationManager = LocationManager()

    lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(remoteNotificationHandler: remoteNotificationHandler,
                              locationManager: locationManager)
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
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

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
            setupHockeyApp()
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
            importShareExtensionLink()
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
            appCoordinator.checkVersionIfNeeded()
            sendSiriEventsIfNeeded()
            QOTService.main.reportAppStatus(.didBecomeActive)
            if SessionService.main.getCurrentSession() != nil {
                self.importHealthKitDataIfAuthorized()
                self.importCalendarEventsIfAuthorized()
                ExternalLinkImporter.main.importLink()
                NotificationCenter.default.post(name: .requestSynchronization, object: nil)
            }
        #endif //#if UNIT_TEST
    }

    func applicationWillResignActive(_ application: UIApplication) {
        #if UNIT_TEST
            return
        #else
            QOTService.main.reportAppStatus(.willResignActive)
        #endif //#if UNIT_TEST
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        if launchHandler.canLaunch(url: url) == true && URLScheme.isLaunchableHost(host: url.host) == true {
            launchHandler.process(url: url)
        }

        return launchHandler.canLaunch(url: url)
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return handleActivity(userActivity: userActivity)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToken = UAUtils.deviceTokenString(fromDeviceToken: deviceToken)
        appCoordinator.apnsDeviceTokenRegistrator.registerDeviceToken(deviceToken)
        UserNotificationsManager.main.scheduleNotifications()
    }

    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        handleShortcut(shortcutItem: shortcutItem)
    }

    func handleShortcut(shortcutItem: UIApplicationShortcutItem) {
        guard
            let linkString = shortcutItem.userInfo?["link"] as? String,
            let link = URL(string: linkString) else { return }
        launchHandler.process(url: link)
    }

    //Interface Orientation
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppCoordinator.orientationManager.supportedOrientations
    }
}

// MARK: - private

private extension AppDelegate {
    func incomingLocationEvent(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        guard let locationEvent = launchOptions?[UIApplicationLaunchOptionsKey.location] as? NSNumber else { return }
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
        UAirship.push().pushNotificationDelegate = remoteNotificationHandler
        UAirship.push().updateRegistration()
        UAirship.shared().analytics.isEnabled = true
    }

    func setupHockeyApp() {
        let hockeyAppID = Bundle.main.object(forInfoDictionaryKey: "HOCKEY_APP_ID") as? String
        BITHockeyManager.shared().configure(withIdentifier: hockeyAppID ?? "4f2cc0d018ea4a2884e052d72eb9c456")
//        #if DEBUG
        BITHockeyManager.shared().isUpdateManagerDisabled = true
//        #endif
        BITHockeyManager.shared().crashManager.crashManagerStatus = BITCrashManagerStatus.autoSend
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
    }

    func setupKingfisherCache() {
        let cache = ImageCache.default
        cache.memoryStorage.config.expiration = .days(1)
        cache.diskStorage.config.expiration = .days(30)
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
        log("dailyPrep://handleNotification, notification:: \(notification)")
        var link: URL?
        if let linkString = notification.request.content.userInfo["link"] as? String {
            link = URL(string: linkString)
        } else if let urlString = notification.request.content.userInfo["url"] as? String {
            link = URL(string: urlString)
        } else {
            let stringValues = notification.request.content.userInfo.values.filter { ($0 is String) } as? [String]
            let userInfoUrlString = stringValues?.filter { $0.contains("qot://") }.first
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
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotification(notification: response.notification)
        completionHandler()
    }
}

// MARK: - NSUserActivity

extension AppDelegate {

    private func handleActivity(userActivity: NSUserActivity) -> Bool {
        var launchURL: URL?
        switch userActivity.activityType {
        case NSUserActivity.ActivityType.toBeVisionGenerator.rawValue,
             NSUserActivity.ActivityType.toBeVision.rawValue:
            launchURL = URLScheme.toBeVision.launchURLWithParameterValue("")
        case NSUserActivity.ActivityType.whatsHotArticle.rawValue:
            launchURL = URLScheme.latestWhatsHotArticle.launchURLWithParameterValue("")
        case NSUserActivity.ActivityType.whatsHotArticlesList.rawValue:
            launchURL = URLScheme.knowFeed.launchURLWithParameterValue("")
        case NSUserActivity.ActivityType.dailyPrep.rawValue:
            launchURL = URLScheme.dailyCheckIn.launchURLWithParameterValue("")
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

// MARK: - Calendar event import
extension AppDelegate {
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

// MARK: - SVProgressHUD

extension AppDelegate {
    private func setupProgressHud() {
        SVProgressHUD.setGraceTimeInterval(0.2)
        SVProgressHUD.setMinimumDismissTimeInterval(0.5)
        SVProgressHUD.setDefaultStyle(.dark)
    }
}

// MARK: - HealthKit Import Data
private extension AppDelegate {
    func importHealthKitDataIfAuthorized() {
        if qot_dal.HealthService.main.isHealthDataAvailable() == true {
            qot_dal.HealthService.main.importHealthKitSleepAnalysisData()
        }
    }
}

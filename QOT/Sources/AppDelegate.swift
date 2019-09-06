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
import RealmSwift
import Buglife
import Alamofire
import Kingfisher
import SVProgressHUD
import qot_dal

protocol LocalNotificationHandlerDelegate: class {
    func localNotificationHandler(_ handler: AppDelegate, canProcessNotification: UNNotification) -> Bool
}

protocol ShortcutHandlerDelegate: class {
    func shortcutHandler(_ handler: AppDelegate, canProcessShortcut shortcutItem: UIApplicationShortcutItem) -> Bool
}

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate, AppStateAccess {

    // MARK: - Properties

    var window: UIWindow?
    private var unhandledNotifications = [UNNotification]()
    private var unhandledShortCuts = [UIApplicationShortcutItem]()
    weak var localNotificationHandlerDelegate: LocalNotificationHandlerDelegate?
    weak var shortcutHandlerDelegate: ShortcutHandlerDelegate?
    lazy var locationManager = LocationManager()

    lazy var windowManager: WindowManager = {
        guard let window = self.window else {
            fatalError("window shouldn't be nil")
        }
        let frame = UIScreen.main.bounds
        let windowManager = WindowManager(
            alertWindow: UIWindow(frame: frame),
            priorityWindow: UIWindow(frame: frame),
            overlayWindow: UIWindow(frame: frame),
            normalWindow: window
        )
        AppDelegate.appState.windowManager = windowManager
        return windowManager
    }()
    lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(windowManager: windowManager,
                              remoteNotificationHandler: remoteNotificationHandler,
                              locationManager: locationManager)
    }()
    lazy var remoteNotificationHandler: RemoteNotificationHandler = {
        return RemoteNotificationHandler(launchHandler: launchHandler)
    }()
    lazy var launchHandler: LaunchHandler = {
        let launchHandler = LaunchHandler()
        AppDelegate.appState.launchHandler = launchHandler
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

        #if UNIT_TEST || BUILD_DATABASE
            Logger.shared.setup()
            #if BUILD_DATABASE
                // @warning REINSTALL before running. Must be logged in
                __buildDatabase()
            #endif
            return true
        #else
            if isRunning {
                return true
            }
            isRunning = true
            ScreenTitleService.main.load()
            _ = UserNotificationsManager.main
            setupProgressHud()
            swizzleUIViewController()
            swizzleUINavigationController()
            Logger.shared.setup()
            window = UIWindow(frame: UIScreen.main.bounds)
            addBadgeObserver()
            if let url = launchOptions?[.url] as? URL {
                RestartHelper.setRestartURL(url)
            }
            appCoordinator.start(completion: {
                if qot_dal.SessionService.main.getCurrentSession() != nil {
                    self.importHealthKitDataIfAuthorized()
                    self.importCalendarEventsIfAuthorized()
                    ExternalLinkImporter.main.importLink()
                }
            })

            incomingLocationEvent(launchOptions: launchOptions)
            setupUAirship()
            setupHockeyApp()
            setupKingfisherCache()
            qot_dal.QOTService.main.reportAppStatus(.start)
            sendSiriEventsIfNeeded()
            return true
        #endif //#if UNIT_TEST || BUILD_DATABASE
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        #if UNIT_TEST || BUILD_DATABASE
            return
        #else
            reachabilityOfSinging()
            importShareExtensionLink()
            appCoordinator.checkVersionIfNeeded()
        #endif //#if UNIT_TEST || BUILD_DATABASE
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        #if UNIT_TEST || BUILD_DATABASE
        return
        #else
            qot_dal.QOTService.main.reportAppStatus(.background)
        #endif //#if UNIT_TEST || BUILD_DATABASE
    }

    func applicationWillTerminate(_ application: UIApplication) {
        #if UNIT_TEST || BUILD_DATABASE
            return
        #else
            qot_dal.QOTService.main.reportAppStatus(.termination)
        #endif
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        #if UNIT_TEST || BUILD_DATABASE
            return
        #else
            appCoordinator.checkVersionIfNeeded()
            sendSiriEventsIfNeeded()
            qot_dal.QOTService.main.reportAppStatus(.didBecomeActive)
            if qot_dal.SessionService.main.getCurrentSession() != nil {
                NotificationCenter.default.post(name: .requestSynchronization, object: nil)
            }
        #endif //#if UNIT_TEST || BUILD_DATABASE
    }

    func applicationWillResignActive(_ application: UIApplication) {
        #if UNIT_TEST || BUILD_DATABASE
            return
        #else
            updateBadgeNumber()
            qot_dal.QOTService.main.reportAppStatus(.willResignActive)
        #endif //#if UNIT_TEST || BUILD_DATABASE
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
        appCoordinator.apnsDeviceTokenRegistrar.registerDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        if shortcutHandlerDelegate?.shortcutHandler(self, canProcessShortcut: shortcutItem) == true {
            handleShortcut(shortcutItem: shortcutItem)
        } else {
            unhandledShortCuts.append(shortcutItem)
        }
    }

    func handleShortcut(shortcutItem: UIApplicationShortcutItem) {
        guard
            let linkString = shortcutItem.userInfo?[JsonKey.link.value] as? String,
            let link = URL(string: linkString) else { return }
        launchHandler.process(url: link)
    }

    func processOutstandingShortcuts() {
        if let shortcut = unhandledShortCuts.first {
            handleShortcut(shortcutItem: shortcut)
            unhandledShortCuts.removeAll()
        }
    }

    //Interface Orientation
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.appState.orientationManager.supportedOrientations
    }
}

// MARK: - private

private extension AppDelegate {

    func addBadgeObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateBadgeNumber),
                                               name: UserDefaults.didChangeNotification,
                                               object: nil)
    }

    @objc func updateBadgeNumber() {
        DispatchQueue.main.async {
            let badgeNumber = UserDefault.whatsHotBadgeNumber.doubleValue.toInt + UserDefault.guideBadgeNumber.doubleValue.toInt
            UIApplication.shared.applicationIconBadgeNumber = badgeNumber
        }
    }

    func reachabilityOfSinging() {
        if let abstractController = AppDelegate.topViewController() as? AbstractFormViewController {
            if ((abstractController.reachability?.isReachable) ?? false) == false {
                abstractController.showSettingsCustomAlert()
            } else {
                abstractController.alert.dismiss(animated: true, completion: nil)
            }
        }
    }

    func incomingLocationEvent(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        guard let locationEvent = launchOptions?[UIApplicationLaunchOptionsKey.location] as? NSNumber else { return }
        if locationEvent.boolValue == true {
            // needs a restart at this point
            qot_dal.QOTService.main.reportDeviceInfo()
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
        #if DEBUG
        BITHockeyManager.shared().isUpdateManagerDisabled = true
        #endif
        BITHockeyManager.shared().crashManager.crashManagerStatus = BITCrashManagerStatus.autoSend
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
    }

    var appFilePath: String {
        let url = URL.documentDirectory.deletingLastPathComponent()
        return url.absoluteString.removeFilePrefix
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

    func processOutstandingNotifications() {
        qot_dal.log("dailyPrep://processOutstandingNotifications:: \(unhandledNotifications)")
        if let notification = unhandledNotifications.first {
            handleNotification(notification: notification)
            unhandledNotifications.removeAll() // TODO: maybe we can handle all of them in the future?
        }
    }

    func handleNotification(notification: UNNotification) {
        qot_dal.log("dailyPrep://handleNotification, notification:: \(notification)")
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
        var notificationID = notification.request.identifier
        if notificationID.starts(with: NotificationID.Prefix.dailyPrep.rawValue) {
            notificationID = NotificationID.dailyPrep(date: Calendar.current.isoDate(from: notification.date)).string
        }
        launchHandler.process(url: notificationLink, notificationID: notificationID)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        qot_dal.log("QOT will present notification:: \(notification)")
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
                switch $0.key {
                case ExtensionUserDefaults.toBeVision.rawValue: break
//                    appCoordinator.sendAppEvent(.siriToBeVision, date: $0.date)
                case ExtensionUserDefaults.whatsHot.rawValue: break
//                    appCoordinator.sendAppEvent(.siriWhatsHot, date: $0.date)
                case ExtensionUserDefaults.upcomingEvents.rawValue: break
//                    appCoordinator.sendAppEvent(.siriUpcomingEvent, date: $0.date)
                case ExtensionUserDefaults.dailyPrep.rawValue: break
//                    appCoordinator.sendAppEvent(.siriDailyPrep, date: $0.date)
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
            qot_dal.CalendarService.main.importCalendarEvents()
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

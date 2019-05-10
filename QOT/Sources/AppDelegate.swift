//
//  AppDelegate.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import AirshipKit
import CoreLocation
import RealmSwift
import Buglife
import Alamofire

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
            Logger.shared.setup()
            window = UIWindow(frame: UIScreen.main.bounds)
            addBadgeObserver()
            Fabric.with([Crashlytics.self])
            if appCoordinator.userLoggedIn == true {
                appCoordinator.startSync()
            }
            appCoordinator.start(completion: {
                self.processURLWhenAppInactive(launchOptions: launchOptions)
            })
            UIApplication.shared.setStatusBarStyle(.lightContent)
            UINavigationBar.appearance().shadowImage = UIImage()
            UITabBar.appearance().shadowImage = UIImage()
            UITabBar.appearance().backgroundImage = UIImage()
            UNUserNotificationCenter.current().delegate = self
            UIApplication.shared.setStatusBar(background: ColorMode.dark.backgroundColor)
            UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.apercuMedium(ofSize: 20),
                                                                .foregroundColor: UIColor.white]
            incomingLocationEvent(launchOptions: launchOptions)
            setupUAirship()
            setupHockeyApp()
            #if DEBUG
                log("\nopen -a \"Realm Browser\" \(DatabaseManager.databaseURL)\n")
            #endif
            appCoordinator.sendAppEvent(.start)
            sendSiriEventsIfNeeded()
            return true
        #endif //#if UNIT_TEST || BUILD_DATABASE
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        #if UNIT_TEST || BUILD_DATABASE
            return
        #else
            reachabilityOfSinging()
            appCoordinator.checkVersionIfNeeded()
            appCoordinator.sendAppEvent(.foreground)
        #endif //#if UNIT_TEST || BUILD_DATABASE
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        #if UNIT_TEST || BUILD_DATABASE
        return
        #else
            appCoordinator.sendAppEvent(.background)
        #endif //#if UNIT_TEST || BUILD_DATABASE
    }

    func applicationWillTerminate(_ application: UIApplication) {
        #if UNIT_TEST || BUILD_DATABASE
            return
        #else
            appCoordinator.sendAppEvent(.termination)
        #endif
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        #if UNIT_TEST || BUILD_DATABASE
            return
        #else
            QOTUsageTimer.sharedInstance.startTimer()
            appCoordinator.appDidBecomeActive()
            appCoordinator.checkVersionIfNeeded()
            sendSiriEventsIfNeeded()
            appCoordinator.sendAppEvent(.didBecomeActive)
        #endif //#if UNIT_TEST || BUILD_DATABASE
    }

    func applicationWillResignActive(_ application: UIApplication) {
        #if UNIT_TEST || BUILD_DATABASE
            return
        #else
            QOTUsageTimer.sharedInstance.stopTimer()
            appCoordinator.sendAppEvent(.willResignActive)
            updateBadgeNumber()
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

    func processURLWhenAppInactive(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        if
            let url = launchOptions?[.url] as? URL,
            launchHandler.canLaunch(url: url) == true,
            URLScheme.isLaunchableHost(host: url.host) {
            launchHandler.process(url: url)
        }
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
            locationManager.startSignificantLocationMonitoring(didUpdateLocations: appCoordinator.sendLocationUpdate)
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
        BITHockeyManager.shared().isUpdateManagerDisabled = true
        BITHockeyManager.shared().crashManager.crashManagerStatus = BITCrashManagerStatus.autoSend
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
    }

    var appFilePath: String {
        let url = URL.documentDirectory.deletingLastPathComponent()
        return url.absoluteString.removeFilePrefix
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
        log("dailyPrep://processOutstandingNotifications:: \(unhandledNotifications)")
        if let notification = unhandledNotifications.first {
            handleNotification(notification: notification)
            unhandledNotifications.removeAll() // TODO: maybe we can handle all of them in the future?
        }
    }

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
        var notificationID = notification.request.identifier
        if notificationID.starts(with: NotificationID.Prefix.dailyPrep.rawValue) {
            notificationID = NotificationID.dailyPrep(date: Calendar.current.isoDate(from: notification.date)).string
        }
        launchHandler.process(url: notificationLink, notificationID: notificationID)
        guard
            let host = notificationLink.host,
            let scheme = URLScheme(rawValue: host), scheme != .dailyPrep,
            let id = try? GuideItemID(stringRepresentation: notificationID) else { return }
        let guideWorker = GuideWorker(services: AppDelegate.appState.services, badgeManager: nil)
        guideWorker.setItemCompleted(id: id)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        log("dailyPrep://userNotificationCenter, willPresent notification:: \(notification)")
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        log("dailyPrep://userNotificationCenter, didReceive response:: \(response.notification)")
        if localNotificationHandlerDelegate?.localNotificationHandler(self,
                                                                      canProcessNotification: response.notification) == true {
            handleNotification(notification: response.notification)
        } else {
            unhandledNotifications.append(response.notification)
        }
        completionHandler()
    }
}

// MARK: - NSUserActivity

extension AppDelegate {

    private func handleActivity(userActivity: NSUserActivity) -> Bool {
        var didHandleActivity = true
        switch userActivity.activityType {
        case NSUserActivity.ActivityType.toBeVision.rawValue:
            appCoordinator.presentToBeVision(articleItemController: nil)
        case NSUserActivity.ActivityType.toBeVisionGenerator.rawValue:
            appCoordinator.presentToBeVisionGenerator()
        case NSUserActivity.ActivityType.whatsHotArticle.rawValue:
            let id = Int(userActivity.contentAttributeSet?.keywords?.first ?? "0") ?? 0
            appCoordinator.presentWhatsHotArticle(with: id)
        case NSUserActivity.ActivityType.whatsHotArticlesList.rawValue:
            appCoordinator.navigate(to: .init(tabBar: .learn, topTabBar: .whatsHotList))
        case NSUserActivity.ActivityType.eventsList.rawValue:
            appCoordinator.navigate(to: .init(tabBar: .prepare, topTabBar: .myPrep))
        case NSUserActivity.ActivityType.event.rawValue:
            let id = userActivity.contentAttributeSet?.keywords?.first ?? ""
            appCoordinator.presentPreparationCheckList(localID: id)
        case NSUserActivity.ActivityType.dailyPrep.rawValue:
            let groupID: Int = Date().isWeekend ? 100010 : 100002
            let date: ISODate = Calendar.current.isoDate(from: Date())
            appCoordinator.presentMorningInterview(groupID: groupID, date: date)
        default:
            didHandleActivity = false
        }
        return didHandleActivity
    }
}

// MARK: - AppEvents/PageTracking

extension AppDelegate {

    func sendSiriEventsIfNeeded() {
        if let events: SiriEventsModel = ExtensionUserDefaults.object(for: .siri, key: .siriAppEvents) {
            events.events.forEach {
                switch $0.key {
                case ExtensionUserDefaults.toBeVision.rawValue:
                    appCoordinator.sendAppEvent(.siriToBeVision, date: $0.date)
                case ExtensionUserDefaults.whatsHot.rawValue:
                    appCoordinator.sendAppEvent(.siriWhatsHot, date: $0.date)
                case ExtensionUserDefaults.upcomingEvents.rawValue:
                    appCoordinator.sendAppEvent(.siriUpcomingEvent, date: $0.date)
                case ExtensionUserDefaults.dailyPrep.rawValue:
                    appCoordinator.sendAppEvent(.siriDailyPrep, date: $0.date)
                default: break
                }
            }
            ExtensionUserDefaults.siriAppEvents.clearWidgetObject()
        }
    }
}

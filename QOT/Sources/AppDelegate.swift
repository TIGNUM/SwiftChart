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
import Siren

protocol LocalNotificationHandlerDelegate: class {

    func localNotificationHandler(_ handler: AppDelegate, canProcessNotification: UNNotification) -> Bool
}

protocol ShortcutHandlerDelegate: class {

    func shortcutHandler(_ handler: AppDelegate, canProcessShortcut shortcutItem: UIApplicationShortcutItem) -> Bool
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppStateAccess {

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
        return AppCoordinator(
            windowManager: self.windowManager,
            remoteNotificationHandler: self.remoteNotificationHandler,
            locationManager: locationManager
        )
    }()
    lazy var remoteNotificationHandler: RemoteNotificationHandler = {
        return RemoteNotificationHandler(launchHandler: self.launchHandler)
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

    // MARK: - Life Cycle

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        #if BUILD_DATABASE
            // @warning REINSTALL before running. Must be logged in
            __buildDatabase()
            return true
        #endif

        Logger.shared.setup()
        Fabric.with([Crashlytics.self])
        appCoordinator.start()
        UIApplication.shared.statusBarStyle = .lightContent
        UNUserNotificationCenter.current().delegate = self
        incomingLocationEvent(launchOptions: launchOptions)
        setupUAirship()
        setupHockeyApp()

        #if DEBUG
            log("\nopen -a \"Realm Browser\" \(DatabaseManager.databaseURL)\n")
        #endif

        sendAppEvent(.start)

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UAirship.push().resetBadge()
        sendAppEvent(.foreground)
        checkVersionIfNeeded()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        sendAppEvent(.termination)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        sendAppEvent(.background)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        QOTUsageTimer.sharedInstance.startTimer()
        UAirship.push().resetBadge()
        appCoordinator.appDidBecomeActive()
        checkVersionIfNeeded()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        QOTUsageTimer.sharedInstance.stopTimer()
    }

    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        if launchHandler.canLaunch(url: url) == true &&
            (url.host == URLScheme.fitbit.rawValue || url.host == URLScheme.preparation.rawValue) {
                launchHandler.process(url: url)
        }

        return launchHandler.canLaunch(url: url)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToken = UAUtils.deviceTokenString(fromDeviceToken: deviceToken)
        appCoordinator.apnsDeviceTokenRegistrar.registerDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        if shortcutHandlerDelegate?.shortcutHandler(self,
                                                    canProcessShortcut: shortcutItem) == true {
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
}

// MARK: - private

private extension AppDelegate {

    func checkVersionIfNeeded() {
        if Siren.shared.alertType == .force {
            Siren.shared.checkVersion(checkType: .immediately)
        } else {
            Siren.shared.checkVersion(checkType: .daily)
        }
    }

    func sendAppEvent(_ event: AppEventRequest.EventType) {
        appCoordinator.networkManager.performAppEventRequest(appEvent: event) { (error) in
            if error != nil {
                log("Failed to performAppEventRequest for event: \(event.rawValue) with: \(String(describing: error))",
                    level: .error)
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
        BITHockeyManager.shared().configure(withIdentifier: "4f2cc0d018ea4a2884e052d72eb9c456")
        BITHockeyManager.shared().isUpdateManagerDisabled = true
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

    class func topViewController(base: UIViewController? =
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController) -> UIViewController? {

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
        guard
            let linkString = notification.request.content.userInfo["link"] as? String,
            let link = URL(string: linkString), launchHandler.canLaunch(url: link) == true else {
                return
        }

        var notificationID = notification.request.identifier
        if notificationID.starts(with: "daily-prep") {
            notificationID = NotificationID.dailyPrep(date: Calendar.current.isoDate(from: notification.date)).string
        }
        launchHandler.process(url: link, notificationID: notificationID)
        guard
            let host = link.host,
            let scheme = URLScheme(rawValue: host), scheme != .dailyPrep,
            let id = try? GuideItemID(stringRepresentation: notificationID) else { return }
        let guideWorker = GuideWorker(services: AppDelegate.appState.services)
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

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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppStateAccess {

    // MARK: - Properties

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
        return AppCoordinator(windowManager: self.windowManager, remoteNotificationHandler: self.remoteNotificationHandler)
    }()
    lazy var remoteNotificationHandler: RemoteNotificationHandler = {
        return RemoteNotificationHandler(launchHandler: self.launchHandler)
    }()
    lazy var launchHandler: LaunchHandler = {
        return LaunchHandler()
    }()

    var window: UIWindow?
    static var current: AppDelegate {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        return app
    }

    // MARK: - Life Cycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        #if BUILD_DATABASE
            // @warning REINSTALL before running. Must be logged in
            __buildDatabase()
            return true
        #endif

        Log.setup()
        Fabric.with([Crashlytics.self])
        Buglife.shared().start(withAPIKey: "fj62sZjDnl3g0dLuXJHUzAtt") // FIXME: obfuscate
        Buglife.shared().delegate = self
        appCoordinator.start()
        UIApplication.shared.statusBarStyle = .lightContent
        UNUserNotificationCenter.current().delegate = self
        incomingLocationEvent(launchOptions: launchOptions)
        setupUAirship()

        #if DEBUG
            log("\nopen -a \"Realm Browser\" \(DatabaseManager.databaseURL)\n")
            logAppLocation()
            logAvailableFonts()
        #endif

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UAirship.push().resetBadge()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        QOTUsageTimer.sharedInstance.startTimer()
        UAirship.push().resetBadge()
        appCoordinator.appDidBecomeActive()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        QOTUsageTimer.sharedInstance.stopTimer()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        if launchHandler.canLaunch(url: url) == true && url.host == URLScheme.fitbit.rawValue {
            launchHandler.process(url: url)
        }

        return launchHandler.canLaunch(url: url)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToken = UAUtils.deviceTokenString(fromDeviceToken: deviceToken)
        appCoordinator.apnsDeviceTokenRegistrar.registerDeviceToken(deviceToken)
    }

    // MARK: - private

    private func incomingLocationEvent(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        guard let locationEvent = launchOptions?[UIApplicationLaunchOptionsKey.location] as? NSNumber else { return }

        if locationEvent.boolValue == true {
            let locationManager = LocationManager()
            locationManager.startSignificantLocationMonitoring(didUpdateLocations: appCoordinator.sendLocationUpdate)
        }
    }

    private func setupUAirship() {
        guard let path = Bundle.main.path(forResource: "AirshipConfig", ofType: "plist") else {
            return
        }

        let config = UAConfig(contentsOfFile: path)
        UAirship.takeOff(config)
        UAirship.push().pushNotificationDelegate = remoteNotificationHandler
        UAirship.push().updateRegistration()
        UAirship.shared().analytics.isEnabled = true
        UAirship.setLogLevel(.error)
    }

    private var appFilePath: String {
        let url = URL.documentsDirectory.deletingLastPathComponent()
        return url.absoluteString.removeFilePrefix
    }

    private func logAppLocation() {
        log("App location: \(appFilePath)", enabled: Log.Toggle.Manager.FileManager)
    }

    private func logAvailableFonts() {
        for family: String in UIFont.familyNames {
            log("\(family)", enabled: Log.Toggle.Manager.Font)
            for names: String in UIFont.fontNames(forFamilyName: family) {
                log("== \(names)", enabled: Log.Toggle.Manager.Font)
            }
        }
    }

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
        guard
            let linkString = notification.request.content.userInfo["link"] as? String,
            let link = URL(string: linkString), launchHandler.canLaunch(url: link) == true else {
                return
        }
        
        let notificationID = notification.request.identifier
        launchHandler.process(url: link, notificationID: notificationID)
        GuideWorker(services: AppDelegate.appState.services).setItemCompleted(guideID: notificationID)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        handleNotification(notification: notification)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        handleNotification(notification: response.notification)
    }
}

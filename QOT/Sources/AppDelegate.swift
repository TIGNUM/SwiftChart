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

extension AppDelegate {

    static var current: AppDelegate {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }

        return app
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(window: self.window!)
    }()
    
    var window: UIWindow?
    fileprivate var canOpenURL = true

    // MARK: - Life Cycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        QOTUsageTimer.sharedInstance.start()
        UIApplication.shared.statusBarStyle = .lightContent
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator.start()
        setupUAirship()

        #if DEBUG
            LogSettings.logLevel = .verbose
            logAppLocation()
            logAvailableFonts()
        #endif
        
        return true
    }

    private func setupUAirship() {
        guard let path = Bundle.main.path(forResource: "AirshipConfig", ofType: "plist") else {
            return
        }

        let config = UAConfig(contentsOfFile: path)
        UAirship.takeOff(config)
        UAirship.push().pushNotificationDelegate = self
        UAirship.shared().analytics.isEnabled = true        
        UAirship.push().updateRegistration()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        QOTUsageTimer.sharedInstance.stopAndSave()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        QOTUsageTimer.sharedInstance.stopAndSave()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UAirship.push().resetBadge()
        QOTUsageTimer.sharedInstance.start()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if canOpenURL == true {
            LaunchHandler.default.process(url: url)
        }

        return true
    }
}

extension AppDelegate {

    fileprivate func logAppLocation() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.deletingLastPathComponent()
        log("App location: \(url)", enabled: LogToggle.Manager.FileManager)
    }

    fileprivate func logAvailableFonts() {
        for family: String in UIFont.familyNames {
            log("\(family)", enabled: LogToggle.Manager.Font)
            for names: String in UIFont.fontNames(forFamilyName: family) {
                log("== \(names)", enabled: LogToggle.Manager.Font)
            }
        }
    }
}

// MARK: - UAPushNotificationDelegate

extension AppDelegate: UAPushNotificationDelegate {

    func receivedNotificationResponse(_ notificationResponse: UANotificationResponse, completionHandler: @escaping () -> Void) {
        canOpenURL = true
        if
            let deepLink = notificationResponse.notificationContent.notificationInfo.values.first as? String,
            let url = URL(string: deepLink) {
                LaunchHandler.default.process(url: url)

        }
        completionHandler()
    }

    func receivedForegroundNotification(_ notificationContent: UANotificationContent, completionHandler: @escaping () -> Void) {
        canOpenURL = false
        completionHandler()
    }

    func presentationOptions(for notification: UNNotification) -> UNNotificationPresentationOptions {
        canOpenURL = false

        return [.alert, .sound]
    }
}

//
//  AppDelegate.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import UserNotifications
import Fabric
import Crashlytics

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

    // MARK: - Life Cycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        QOTUsageTimer.sharedInstance.start()
        UIApplication.shared.statusBarStyle = .lightContent
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator.start()

        #if DEBUG
            LogSettings.logLevel = .verbose
            logAppLocation()
            logAvailableFonts()
        #endif
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        QOTUsageTimer.sharedInstance.stopAndSave()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        QOTUsageTimer.sharedInstance.stopAndSave()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        QOTUsageTimer.sharedInstance.start()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url.absoluteString)
        CustomAppLaunchHandler.process(urlString: url.absoluteString)

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        appCoordinator.remoteNotificationHandler.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        appCoordinator.remoteNotificationHandler.didFailToRegisterForRemoteNotificationsWithError(error)
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

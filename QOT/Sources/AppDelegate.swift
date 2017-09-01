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
import Realm
import Buglife

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    lazy var windowManager: WindowManager = {
        guard let window = self.window else {
            fatalError("window shouldn't be nil")
        }
        let frame = UIScreen.main.bounds
        return WindowManager(
            alertWindow: UIWindow(frame: frame),
            priorityWindow: UIWindow(frame: frame),
            overlayWindow: UIWindow(frame: frame),
            normalWindow: window)
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
        
        Fabric.with([Crashlytics.self])
        Buglife.shared().start(withAPIKey: "fj62sZjDnl3g0dLuXJHUzAtt") // FIXME: obfuscate
        QOTUsageTimer.sharedInstance.start()
        appCoordinator.start()
        UIApplication.shared.statusBarStyle = .lightContent
        setupUAirship()        

        #if DEBUG
            log("\nopen -a \"Realm Browser\" \(RealmProvider.config.fileURL!)\n")
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
        UAirship.push().resetBadge()
        QOTUsageTimer.sharedInstance.start()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UAirship.push().resetBadge()
        appCoordinator.appDidBecomeActive()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return launchHandler.canLaunch(url: url)
    }
    
    // MARK: - private
    
    private func setupUAirship() {
        guard let path = Bundle.main.path(forResource: "AirshipConfig", ofType: "plist") else {
            return
        }
        
        let config = UAConfig(contentsOfFile: path)
        UAirship.takeOff(config)
        UAirship.push().pushNotificationDelegate = remoteNotificationHandler
        UAirship.shared().analytics.isEnabled = true
        UAirship.push().updateRegistration()
    }

    fileprivate var appFilePath: String {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.deletingLastPathComponent()
        return url.absoluteString.removeFilePrefix
    }
    
    fileprivate func logAppLocation() {
        log("App location: \(appFilePath)", enabled: LogToggle.Manager.FileManager)
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

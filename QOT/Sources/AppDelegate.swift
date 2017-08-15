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
    
    #if BUILD_DATABASE
    lazy var databaseBuilder: DatabaseBuilder = {
        let realmProvider = RealmProvider()
        return DatabaseBuilder(
            config: RealmProvider.config,
            networkManager: NetworkManager(),
            syncRecordService: SyncRecordService(realmProvider: realmProvider),
            realmProvider: realmProvider
        )
    }()
    #endif

    var window: UIWindow?
    fileprivate var canOpenURL = true

    // MARK: - Life Cycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        #if BUILD_DATABASE
            // @warning REINSTALL before running
            __buildDatabase()
            return true
        #endif
        
        Fabric.with([Crashlytics.self])
        QOTUsageTimer.sharedInstance.start()
        UIApplication.shared.statusBarStyle = .lightContent
        appCoordinator.start()
        setupUAirship()

        #if DEBUG
            print("PATH: \(RLMRealmConfiguration.default().fileURL!)")
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

    func applicationDidBecomeActive(_ application: UIApplication) {
        appCoordinator.appDidBecomeActive()

        //TODO: comment in to test
//        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
//            self.appCoordinator.presentMorningInterview(groupID: 100002, validFrom: Date(), validTo: Date())
//        }
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if canOpenURL == true {
            LaunchHandler.default.process(url: url)
        }

        return true
    }
}

extension AppDelegate {

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

// MARK: - BUILD_DATABASE

#if BUILD_DATABASE
extension AppDelegate {
    fileprivate func __buildDatabase() {
        log("\nbuild database started (may take some time - get a tea...)\n")
        
        let context = SyncContext()
        
        databaseBuilder.setContentOperations([
            databaseBuilder.downSyncOperation(for: ContentCategory.self, context: context),
            databaseBuilder.downSyncOperation(for: ContentCollection.self, context: context),
            databaseBuilder.downSyncOperation(for: ContentItem.self, context: context),
            databaseBuilder.updateRelationsOperation(context: context)
        ])
        databaseBuilder.setCompletion({
            guard context.errors.count == 0 else {
                log(context.errors[0].localizedDescription)
                return
            }
            
            do {
                let name = "default-v1.realm"
                let fileURL = try self.databaseBuilder.copyWithName(name)
                log("\nbuild database completed successfully. paste this into terminal:")
                log("cd <qot project>")
                log("cp \"\(fileURL!.absoluteString.removeFilePrefix)\" \"QOT/Resources/Database/\(name)\"")
                log("\nnow verify it by opening the database:")
                log("open \"QOT/Resources/Database/\(name)\"")
                log("\nthen close Realm browser, and remove all the crap:")
                log("rm QOT/Resources/Database/*.lock;rm -r QOT/Resources/Database/*.management;rm QOT/Resources/Database/*.note")
            } catch {
                log("\nbuild database failed with error: \(error.localizedDescription)")
            }
        })
        databaseBuilder.build()
    }
}
#endif

//
//  AppDelegate.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import UserNotifications

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

    static var enterDate = Date()
    fileprivate let requestIdentifier = "qot.local.notification.morning.interview"

    fileprivate lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(window: self.window!)
    }()
    
    var window: UIWindow?

    // MARK: - Life Cycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.enterDate = Date()
        UIApplication.shared.statusBarStyle = .lightContent
        registerLocal()
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
        AppDelegate.storeQotUsageTime()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        AppDelegate.storeQotUsageTime()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        AppDelegate.enterDate = Date()
    }

    static func storeQotUsageTime() {
        let qotSeconds = UserDefault.qotUsage.intValue
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.second], from: enterDate, to: Date())
        let totalSeconds = qotSeconds + (components.second ?? 0)
        UserDefault.qotUsage.setIntValue(value: totalSeconds)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        AddSensorCoordinator.safariViewController?.dismiss(animated: true, completion: nil)
        SensorAuthorisationHandler.process(urlString: url.absoluteString)

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

// MARK: - Notifications

extension AppDelegate: UNUserNotificationCenterDelegate {

    fileprivate func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { _ in }
    }

    private func triggerNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Good Morning"
        content.subtitle = "Lets start the day with a quick interview."
        content.body = "Its about your qualitiy of sleep and will take not longer then 2 minutes."
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print(error?.localizedDescription ?? "Notification Error")
            }
        }
    }

    func shouldTriggerNotification() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.triggerNotification()
            } else {
                self.appCoordinator.showAlert(type: .notificationsNotAuthorized, handler: {
                    UIApplication.openAppSettings()
                }, handlerDestructive: nil)
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == requestIdentifier {
            completionHandler()
            appCoordinator.presentMorningInterview()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if notification.request.identifier == requestIdentifier {
            completionHandler( [.alert, .sound, .badge])
        }
    }
}

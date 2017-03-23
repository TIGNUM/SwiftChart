//
//  AppDelegate.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    private lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(window: self.window!)
    }()
    
    var window: UIWindow?

    // MARK: - Life Cycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {        
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator.start()
        
        #if DEBUG
            LogSettings.shouldShowDetailedLogs = true
            logAppLocation()
            logAvailableFonts()
        #endif
        
        return true
    }
}

extension AppDelegate {

    fileprivate func logAppLocation() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.deletingLastPathComponent()
        log(Verbose.Manager.FileManager, "App location: \(url)")
    }

    fileprivate func logAvailableFonts() {
        for family: String in UIFont.familyNames {
            log(Verbose.Manager.Font, "\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family) {
                log(Verbose.Manager.Font, "== \(names)")
            }
        }
    }
}

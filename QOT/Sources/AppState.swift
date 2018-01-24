//
//  AppState.swift
//  QOT
//
//  Created by Sam Wyndham on 06.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

/**
 A singleton for passing app state to `Configurator`s. Access to this is only possible by conforming to
 `AppStateAccess`.
 */
final class AppState {

    fileprivate static var shared = AppState()

    var services: Services!
    var windowManager: WindowManager!
    var appCoordinator: AppCoordinator!
    var launchHandler: LaunchHandler!

    private init() {}
}

/**
 Conforming types get access to the `AppState` singleton.
 - warning: Only `Configurator`s and `AppCoordinator` should conform to this protocol! Do not abuse!
 */
protocol AppStateAccess {}

extension AppStateAccess {

    static var appState: AppState {
        return AppState.shared
    }
}

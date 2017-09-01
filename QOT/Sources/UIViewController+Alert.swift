//
//  UIViewController+Alert.swift
//  QOT
//
//  Created by karmic on 27.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import MBProgressHUD

enum AlertType {
    case empty
    case fitbit
    case fitbitSuccess
    case fitbitFailure
    case noContent
    case custom(title: String, message: String)
    case unauthenticated
    case noNetworkConnection
    case comingSoon
    case unknow
    case loginFailed
    case notificationsNotAuthorized
    case tutorialReset
    case settingsLoccationService
    case settingsCalendars
    case emailNotFound

    var title: String? {
        switch self {
        case .fitbitSuccess: return R.string.localized.sidebarSensorsMenuFitbitSuccess()
        case .fitbitFailure: return R.string.localized.sidebarSensorsMenuFitbitFailure()
        case .noContent: return R.string.localized.alertTitleNoContent()
        case .custom(let title, _): return title
        case .unauthenticated: return R.string.localized.alertTitleUnauthenticated()
        case .noNetworkConnection: return R.string.localized.alertTitleNoNetworkConnection()
        case .unknow: return R.string.localized.alertTitleUnknown()
        case .loginFailed: return R.string.localized.loginViewLoginFailed()
        case .notificationsNotAuthorized: return R.string.localized.alertTitleNotificationsNotAuthorized()
        case .tutorialReset: return R.string.localized.settingsTutorialResetTitle()
        case .settingsLoccationService: return R.string.localized.alertTitleLocationServices()
        case .settingsCalendars: return R.string.localized.alertTitleCalendarNoAccess()
        case .emailNotFound: return R.string.localized.alertTitleEmailNotFound()
        default: return nil
        }
    }

    var message: String? {
        switch self {
        case .noContent: return R.string.localized.alertMessageNoContent()
        case .custom(_, let message): return message
        case .unauthenticated: return R.string.localized.alertMessageUnauthenticated()
        case .noNetworkConnection: return R.string.localized.alertMessageNoNetworkConnection()
        case .comingSoon: return R.string.localized.alertMessageComingSoon()
        case .unknow: return R.string.localized.alertMessageUnknown()
        case .notificationsNotAuthorized: return R.string.localized.alertMessageNotificationsNotAuthorized()
        case .settingsLoccationService: return R.string.localized.alertMessageLocationServices()
        case .settingsCalendars: return R.string.localized.alertMessageCalendarNoAccess()
        case .emailNotFound: return R.string.localized.alertMessageEmailNotFound()
        default: return nil
        }
    }

    var buttonTitleCancel: String? {
        switch self {
        case .notificationsNotAuthorized,
             .settingsLoccationService,
             .settingsCalendars: return R.string.localized.alertButtonTitleCancel()
        default: return nil
        }
    }

    var buttonTitleDefault: String? {
        switch self {
        case .notificationsNotAuthorized,
             .settingsLoccationService,
             .settingsCalendars: return R.string.localized.alertButtonTitleOpenSettings()
        default: return R.string.localized.alertButtonTitleOk()
        }
    }

    var buttonTitleDestructive: String? {
        switch self {
        default: return nil
        }
    }

    var actionStyle: [UIAlertActionStyle] {
        switch self {
        case .notificationsNotAuthorized,
             .settingsLoccationService,
             .settingsCalendars: return [.cancel, .default]
        default: return [.default]
        }
    }

    var alertStyle: UIAlertControllerStyle {
        switch self {
        default: return .alert
        }
    }

    /**
     * ONLY FOR PROGRESS HUD
     * minShowTime: Minimum amount of time the HUD will be displayed
     */
    var minShowTime: TimeInterval {
        switch self {
        case .fitbitSuccess: return 1
        case .fitbitFailure: return 1
        case .custom: return 1
        case .unauthenticated: return 1
        case .noNetworkConnection: return 1
        case .loginFailed: return 1
        default: return 0.5
        }
    }

    /**
     * ONLY FOR PROGRESS HUD
     * graceTime: Time after which the HUD will be displayed. If action is finished before this time is over the HUD won't be displayed
     */
    var graceTime: TimeInterval {
        switch self {
        default: return 0
        }
    }

    /**
     * ONLY FOR PROGRESS HUD
     * mode: HUD display mode
     */
    var mode: MBProgressHUDMode {
        switch self {
        default: return .indeterminate
        }
    }

    /**
     * ONLY FOR PROGRESS HUD
     * animationType: Progress animation type
     */
    var animationType: MBProgressHUDAnimation {
        switch self {
        default: return .fade
        }
    }

    /**
     * ONLY FOR PROGRESS HUD
     * isSquare: Try to set the HUD in a square format
     */
    var isSquare: Bool {
        switch self {
        default: return false
        }
    }
}

// MARK: - Alert

extension UIViewController {

    class func alert(forType type: AlertType, handler: (() -> Void)? = nil, handlerDestructive: (() -> Void)? = nil) -> UIAlertController {
        let alertController = UIViewController.alertController(type: type)
        addActions(type: type, alertController: alertController, handler: handler, handlerDestructive: handlerDestructive)
        return alertController
    }
    
    func showAlert(type: AlertType, handler: (() -> Void)? = nil, handlerDestructive: (() -> Void)? = nil) {
        let alertController = UIViewController.alertController(type: type)
        UIViewController.addActions(type: type, alertController: alertController, handler: handler, handlerDestructive: handlerDestructive)
        self.present(alertController, animated: true, completion: nil)
    }

    private class func addActions(type: AlertType, alertController: UIAlertController, handler: (() -> Void)?, handlerDestructive: (() -> Void)?) {
        for style in type.actionStyle {
            self.addActionStyle(style: style, alertController: alertController, type: type, handler: handler, handlerDestructive: handlerDestructive)
        }
    }

    private class func addActionStyle(style: UIAlertActionStyle, alertController: UIAlertController, type: AlertType, handler: (() -> Void)?, handlerDestructive: (() -> Void)?) {
        switch style {
        case .cancel: alertController.addAction(UIViewController.cancelAction(type: type))
        case .default: alertController.addAction(UIViewController.defaultAction(type: type, handler: handler))
        case .destructive: alertController.addAction(UIViewController.destructiveAction(type: type, handler: handlerDestructive))
        }
    }

    private class func alertController(type: AlertType) -> UIAlertController {
        return UIAlertController(title: type.title, message: type.message, preferredStyle: type.alertStyle)
    }

    private class func cancelAction(type: AlertType) -> UIAlertAction {
        return UIAlertAction(title: type.buttonTitleCancel, style: .cancel, handler: nil)
    }
    
    private class func defaultAction(type: AlertType, handler: (() -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: type.buttonTitleDefault, style: .default) { _ in
            handler?()
        }
    }
    
    private class func destructiveAction(type: AlertType, handler: (() -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: type.buttonTitleDestructive, style: .destructive) { _ in
            handler?()
        }
    }
}

//
//  UIViewController+Alert.swift
//  QOT
//
//  Created by karmic on 27.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

enum AlertType {
    case empty
    case fitbit
    case fitbitSuccess
    case fitbitFailure
    case fitbitAlreadyConnected
    case noContent
    case title(String)
    case message(String)
    case custom(title: String, message: String)
    case unauthenticated
    case noNetworkConnection
    case comingSoon
    case unknown
    case loginFailed
    case notificationsNotAuthorized
    case tutorialReset
    case settingsLoccationService
    case settingsCalendars
    case emailNotFound
    case cameraNotAvailable
    case permissionNotGranted
    case imagePicker
    case notSynced
    case resetPassword

    var title: String? {
        switch self {
        case .fitbitSuccess: return R.string.localized.sidebarSensorsMenuFitbitSuccess()
        case .fitbitFailure: return R.string.localized.sidebarSensorsMenuFitbitFailure()
        case .fitbitAlreadyConnected: return R.string.localized.sidebarSensorsMenuFitbitAlreadyConnectedTitle()
        case .noContent: return R.string.localized.alertTitleNoContent()
        case .custom(let title, _): return title
        case .title(let title): return title
        case .unauthenticated: return R.string.localized.alertTitleUnauthenticated()
        case .noNetworkConnection: return R.string.localized.alertTitleNoNetworkConnection()
        case .unknown: return R.string.localized.alertTitleUnknown()
        case .loginFailed: return R.string.localized.loginViewLoginFailed()
        case .notificationsNotAuthorized: return R.string.localized.alertTitleNotificationsNotAuthorized()
        case .tutorialReset: return R.string.localized.settingsTutorialResetTitle()
        case .settingsLoccationService: return R.string.localized.alertTitleLocationServices()
        case .settingsCalendars: return R.string.localized.alertTitleCalendarNoAccess()
        case .emailNotFound: return R.string.localized.alertTitleEmailNotFound()
        case .cameraNotAvailable, .permissionNotGranted: return R.string.localized.alertTitleCustom()
        case .resetPassword: return R.string.localized.alertTitleResetPassword()
        default: return nil
        }
    }

    var message: String? {
        switch self {
        case .noContent: return R.string.localized.alertMessageNoContent()
        case .custom(_, let message): return message
        case .message(let message): return message
        case .unauthenticated: return R.string.localized.alertMessageUnauthenticated()
        case .noNetworkConnection: return R.string.localized.alertMessageNoNetworkConnection()
        case .comingSoon: return R.string.localized.alertMessageComingSoon()
        case .unknown: return R.string.localized.alertMessageUnknown()
        case .notificationsNotAuthorized: return R.string.localized.alertMessageNotificationsNotAuthorized()
        case .settingsLoccationService: return R.string.localized.alertMessageLocationServices()
        case .settingsCalendars: return R.string.localized.alertMessageCalendarNoAccess()
        case .emailNotFound: return R.string.localized.alertMessageEmailNotFound()
        case .cameraNotAvailable: return R.string.localized.alertCameraNotAvailableMessage()
        case .permissionNotGranted: return R.string.localized.alertPermissionNotGrantedMessage()
        case .notSynced: return R.string.localized.alertNotSyncedMessage()
        case .fitbitAlreadyConnected: return R.string.localized.sidebarSensorsMenuFitbitAlreadyConnectedMessage()
        case .resetPassword: return R.string.localized.alertMessageResetPassword()
        default: return nil
        }
    }

    var buttonTitleCancel: String? {
        switch self {
        case .notificationsNotAuthorized,
             .settingsLoccationService,
             .settingsCalendars,
             .imagePicker: return R.string.localized.alertButtonTitleCancel()
        default: return nil
        }
    }

    var buttonTitleDefault: String? {
        switch self {
        case .notificationsNotAuthorized,
             .settingsLoccationService,
             .settingsCalendars: return R.string.localized.alertButtonTitleOpenSettings()
        case .imagePicker: return R.string.localized.imagePickerOptionsButtonPhoto()
        default: return R.string.localized.alertButtonTitleOk()
        }
    }

    var buttonTitleDestructive: String? {
        switch self {
        case .imagePicker: return R.string.localized.imagePickerOptionsButtonCamera()
        default: return nil
        }
    }

    var actionStyle: [UIAlertActionStyle] {
        switch self {
        case .notificationsNotAuthorized,
             .settingsLoccationService,
             .settingsCalendars: return [.cancel, .default]
        case .imagePicker: return [.cancel]
        default: return [.default]
        }
    }

    var alertStyle: UIAlertControllerStyle {
        switch self {
        case .imagePicker: return .actionSheet
        default: return .alert
        }
    }

    static func makeCustom(title: String?, message: String?) -> AlertType? {
        if let title = title, let message = message {
            return .custom(title: title, message: message)
        } else if let title = title {
            return .title(title)
        } else if let message = message {
            return .message(message)
        } else {
            return nil
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

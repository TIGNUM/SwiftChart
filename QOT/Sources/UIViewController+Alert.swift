//
//  UIViewController+Alert.swift
//  QOT
//
//  Created by karmic on 27.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import qot_dal

enum AlertType {
    case title(String)
    case message(String)
    case custom(title: String, message: String)
    case dbError
    case noNetworkConnection
    case noNetworkConnectionFile
    case unknown
    case loginFailed
    case emailNotFound
    case cameraNotAvailable
    case changeNotifications
    case calendarNotSynced
    case photosPermissionNotAuthorized
    case cameraPermissionNotAuthorized

    var title: String? {
        switch self {
        case .custom(let title, _): return title
        case .title(let title): return title
        case .dbError: return AppTextService.get(AppTextKey.startup_alert_database_error_title)
        case .noNetworkConnection,
             .noNetworkConnectionFile: return AppTextService.get(AppTextKey.generic_alert_no_network_connection_title)
        case .unknown: return AppTextService.get(AppTextKey.generic_alert_unknown_title)
        case .loginFailed: return AppTextService.get(AppTextKey.login_alert_failed_title)
        case .emailNotFound: return AppTextService.get(AppTextKey.login_alert_email_not_found_title)
        case .cameraNotAvailable: return AppTextService.get(AppTextKey.my_qot_my_to_be_vision_alert_camera_not_available_title)
        case .calendarNotSynced: return AppTextService.get(AppTextKey.coach_prepare_alert_calendar_not_synced_title)
        case .changeNotifications: return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_notifications_alert_change_notifications_title)
        default: return nil
        }
    }

    var message: String? {
        switch self {
        case .custom(_, let message): return message
        case .message(let message): return message
        case .dbError: return AppTextService.get(AppTextKey.startup_alert_database_error_body)
        case .noNetworkConnection: return AppTextService.get(AppTextKey.generic_alert_no_network_connection_message_title)
        case .noNetworkConnectionFile: return AppTextService.get(AppTextKey.generic_alert_no_network_connection_file)
        case .unknown: return AppTextService.get(AppTextKey.generic_alert_unknown_message_title)
        case .emailNotFound: return AppTextService.get(AppTextKey.login_alert_email_not_found_body)
        case .photosPermissionNotAuthorized: return AppTextService.get(AppTextKey.my_qot_my_to_be_vision_alert_photo_not_granted_body)
        case .cameraPermissionNotAuthorized: return AppTextService.get(AppTextKey.my_qot_my_to_be_vision_alert_camera_not_granted_body)
        case .cameraNotAvailable: return AppTextService.get(AppTextKey.my_qot_my_to_be_vision_alert_camera_not_available_body)
        case .calendarNotSynced: return AppTextService.get(AppTextKey.coach_prepare_alert_calendar_not_synced_body)
        case .changeNotifications: return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_notifications_alert_change_notifications_body)
        default: return nil
        }
    }

    var buttonTitleCancel: String? {
        switch self {
        case .changeNotifications,
             .photosPermissionNotAuthorized,
             .cameraPermissionNotAuthorized: return AppTextService.get(AppTextKey.generic_view_cancel_button_title)
        default: return nil
        }
    }

    var buttonTitleDefault: String? {
        switch self {
        case .changeNotifications: return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_notifications_alert_open_settings_title)
        case .photosPermissionNotAuthorized,
             .cameraPermissionNotAuthorized: return AppTextService.get(AppTextKey.my_qot_my_to_be_vision_alert_settings_title)
        default: return AppTextService.get(AppTextKey.generic_alert_ok_button)
        }
    }

    var buttonTitleDestructive: String? {
        switch self {
        case .photosPermissionNotAuthorized,
             .cameraPermissionNotAuthorized,
             .changeNotifications: return AppTextService.get(AppTextKey.generic_view_cancel_button_title)
        default: return nil
        }
    }

    var actionStyle: [UIAlertActionStyle] {
        switch self {
        case .cameraPermissionNotAuthorized,
             .photosPermissionNotAuthorized,
             .changeNotifications: return [.destructive, .default]
        default: return [.default]
        }
    }

    var alertStyle: UIAlertControllerStyle {
        return .alert
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

    class func alert(forType type: AlertType,
                     handler: (() -> Void)? = nil,
                     handlerDestructive: (() -> Void)? = nil) -> UIAlertController {
        let alertController = UIViewController.alertController(type: type)
        addActions(type: type,
                   alertController: alertController,
                   handler: handler,
                   handlerDestructive: handlerDestructive)
        return alertController
    }

    func showAlert(type: AlertType, handler: (() -> Void)? = nil, handlerDestructive: (() -> Void)? = nil) {
        let alertController = UIViewController.alertController(type: type)
        UIViewController.addActions(type: type,
                                    alertController: alertController,
                                    handler: handler,
                                    handlerDestructive: handlerDestructive)
        self.present(alertController, animated: true, completion: nil)
    }

    private class func addActions(type: AlertType,
                                  alertController: UIAlertController,
                                  handler: (() -> Void)?,
                                  handlerDestructive: (() -> Void)?) {
        for style in type.actionStyle {
            self.addActionStyle(style: style,
                                alertController: alertController,
                                type: type,
                                handler: handler,
                                handlerDestructive: handlerDestructive)
        }
    }

    private class func addActionStyle(style: UIAlertActionStyle,
                                      alertController: UIAlertController,
                                      type: AlertType,
                                      handler: (() -> Void)?,
                                      handlerDestructive: (() -> Void)?) {
        switch style {
        case .cancel: alertController.addAction(UIViewController.cancelAction(type: type))
        case .default: alertController.addAction(UIViewController.defaultAction(type: type, handler: handler))
        case .destructive: alertController.addAction(UIViewController.destructiveAction(type: type,
                                                                                        handler: handlerDestructive))
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

extension UIViewController {

    func handleError(_ error: Error?) {
        qot_dal.log("Failed to login with error: \(String(describing: error?.localizedDescription)))", level: .error)
        if let networkError = error as? QOTNetworkError {
            switch networkError.type {
            case .unauthenticated: showAlert(type: .loginFailed)
            case .noNetworkConnection: showAlert(type: .noNetworkConnection)
            case .cancelled: showAlert(messageType: "cancelled")
            case .failedToParseData(let data, let error):
                showAlert(messageType: String(format: "data: %@\nError: %@",
                                               data.base64EncodedString(),
                                               error.localizedDescription))
            case .notFound: showAlert(messageType: "notFound")
            case .unknown(let error, let statusCode):
                showAlert(messageType: String(format: "error: %@\nStatusCode: %d",
                                               error?.localizedDescription ?? "", statusCode ?? 0))
            case .badRequest: showAlert(messageType: "Bad Request")
            case .unknownError: showAlert(type: .unknown)
            case .forbidden: showAlert(messageType: "Forbidden")
            }
        } else {
            showAlert(type: .unknown)
        }
    }

    func showAlert(messageType: String) {
        let title = AppTextService.get(AppTextKey.generic_alert_custom_title)
        let message = AppTextService.get(AppTextKey.generic_alert_unknown_message_custom_body).replacingOccurrences(of: "%@", with: messageType)
        showAlert(type: .custom(title: title, message: message))
    }
}

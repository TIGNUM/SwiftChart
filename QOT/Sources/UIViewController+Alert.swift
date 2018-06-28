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
    case noNetworkConnectionFile
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
    case canNotUploadPhoto
    case canNotSendMail
    case canNotSendEmailToBeVision
    case canNotSendEmailWeeklyChoices
    case prepareEditStrategy
    case changePermissions
    case toBeVisionActionSheet
    case partnerIncomplete
    case canNotDeletePartner
    case logout
    case noWeeklyChoice
    case noMyToBeVision

    var title: String? {
        switch self {
        case .fitbitSuccess: return R.string.localized.sidebarSensorsMenuFitbitSuccess()
        case .fitbitFailure: return R.string.localized.sidebarSensorsMenuFitbitFailure()
        case .fitbitAlreadyConnected: return R.string.localized.sidebarSensorsMenuFitbitAlreadyConnectedTitle()
        case .noContent: return R.string.localized.alertTitleNoContent()
        case .custom(let title, _): return title
        case .title(let title): return title
        case .unauthenticated: return R.string.localized.alertTitleUnauthenticated()
        case .noNetworkConnection,
             .noNetworkConnectionFile: return R.string.localized.alertTitleNoNetworkConnection()
        case .unknown: return R.string.localized.alertTitleUnknown()
        case .loginFailed: return R.string.localized.loginViewLoginFailed()
        case .notificationsNotAuthorized: return R.string.localized.alertTitleNotificationsNotAuthorized()
        case .tutorialReset: return R.string.localized.settingsTutorialResetTitle()
        case .settingsLoccationService: return R.string.localized.alertTitleLocationServices()
        case .settingsCalendars: return R.string.localized.alertTitleCalendarNoAccess()
        case .emailNotFound: return R.string.localized.alertTitleEmailNotFound()
        case .cameraNotAvailable, .permissionNotGranted: return R.string.localized.alertTitleCustom()
        case .resetPassword: return R.string.localized.alertTitleResetPassword()
        case .canNotUploadPhoto: return R.string.localized.meSectorMyWhyPartnersPhotoErrorTitle()
        case .canNotSendMail,
             .canNotSendEmailToBeVision,
             .canNotSendEmailWeeklyChoices: return R.string.localized.alertTitleCouldNotSendEmail()
        case .prepareEditStrategy: return R.string.localized.alertTitlePreparationEditStrategy()
        case .changePermissions: return R.string.localized.alertTitleSettingsChangePermission()
        case .partnerIncomplete: return R.string.localized.partnersAlertImcompleteTitle()
        case .canNotDeletePartner: return R.string.localized.partnersAlertDeleteErrorTitle()
        case .logout: return R.string.localized.sidebarTitleLogout()
        case .noMyToBeVision,
             .noWeeklyChoice : return R.string.localized.meSectorMyWhyPartnersShareNoContentTitle()
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
        case .noNetworkConnectionFile: return R.string.localized.alertMessageNoNetworkConnectionFile()
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
        case .canNotUploadPhoto: return R.string.localized.meSectorMyWhyPartnersPhotoErrorMessage()
        case .canNotSendMail: return R.string.localized.alertMessageCouldNotSendEmail()
        case .canNotSendEmailToBeVision: return R.string.localized.alertMessageCouldNotSendEmailToBeVision()
        case .canNotSendEmailWeeklyChoices: return R.string.localized.alertMessageCouldNotSendEmailWeeklyChoices()
        case .prepareEditStrategy: return R.string.localized.alertMessagePreparationEditStrategy()
        case .changePermissions: return R.string.localized.alertMessageSettingsChangePermission()
        case .partnerIncomplete: return R.string.localized.partnersAlertImcompleteMessage()
        case .canNotDeletePartner: return R.string.localized.partnersAlertDeleteErrorMessage()
        case .logout: return R.string.localized.alertMessageLogout()
        case .noMyToBeVision: return R.string.localized.meSectorMyWhyPartnersShareMissingMyToBeVisionAlert()
        case .noWeeklyChoice: return R.string.localized.meSectorMyWhyPartnersShareMissingWeeklyChoiceAlert()
        default: return nil
        }
    }

    var buttonTitleCancel: String? {
        switch self {
        case .notificationsNotAuthorized,
             .settingsLoccationService,
             .settingsCalendars,
             .imagePicker,
             .changePermissions,
             .toBeVisionActionSheet,
             .prepareEditStrategy,
             .logout: return R.string.localized.alertButtonTitleCancel()
        default: return nil
        }
    }

    var buttonTitleDefault: String? {
        switch self {
        case .notificationsNotAuthorized,
             .settingsLoccationService,
             .settingsCalendars,
             .changePermissions: return R.string.localized.alertButtonTitleOpenSettings()
        case .imagePicker: return R.string.localized.imagePickerOptionsButtonPhoto()
        case .prepareEditStrategy: return R.string.localized.alertTitlePreparationAddStrategy()
        case .logout: return R.string.localized.alertButtonTitleCancel()
        default: return R.string.localized.alertButtonTitleOk()
        }
    }

    var buttonTitleDestructive: String? {
        switch self {
        case .changePermissions: return R.string.localized.alertButtonTitleCancel()
        case .imagePicker: return R.string.localized.imagePickerOptionsButtonCamera()
        case .prepareEditStrategy: return R.string.localized.alertTitlePreparationRemoveStrategy()
        case .logout: return R.string.localized.sidebarTitleLogout()
        default: return nil
        }
    }

    var actionStyle: [UIAlertActionStyle] {
        switch self {
        case .notificationsNotAuthorized,
             .settingsLoccationService,
             .settingsCalendars: return [.cancel, .default]
        case .imagePicker,
             .toBeVisionActionSheet: return [.cancel]
        case .logout: return [.destructive, .cancel]
        case .prepareEditStrategy: return [.default, .destructive, .cancel]
        case .changePermissions: return [.destructive, .default]
        default: return [.default]
        }
    }

    var alertStyle: UIAlertControllerStyle {
        switch self {
        case .imagePicker,
             .prepareEditStrategy,
             .toBeVisionActionSheet,
             .logout: return .actionSheet
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
                                      type: AlertType, handler: (() -> Void)?,
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
        log("Failed to login with error: \(String(describing: error?.localizedDescription)))", level: .error)
        if let networkError = error as? NetworkError {
            switch networkError.type {
            case .unauthenticated: showAlert(type: .loginFailed)
            case .noNetworkConnection: showAlert(type: .noNetworkConnection)
            case .cancelled: showAlert(messaggeType: "cancelled")
            case .failedToParseData(let data, let error):
                showAlert(messaggeType: String(format: "data: %@\nError: %@",
                                               data.base64EncodedString(),
                                               error.localizedDescription))
            case .notFound: showAlert(messaggeType: "notFound")
            case .unknown(let error, let statusCode):
                showAlert(messaggeType: String(format: "error: %@\nStatusCode: %d",
                                               error.localizedDescription, statusCode ?? 0))
            case .unknownError: showAlert(type: .unknown)
            }
        } else {
            showAlert(type: .unknown)
        }
    }

    func showAlert(messaggeType: String) {
        let message = R.string.localized.alertMessageUnknownType(messaggeType)
        let title = R.string.localized.alertTitleCustom()
        showAlert(type: .custom(title: title, message: message))
    }
}

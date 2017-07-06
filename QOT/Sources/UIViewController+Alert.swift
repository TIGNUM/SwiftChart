//
//  UIViewController+Alert.swift
//  QOT
//
//  Created by karmic on 27.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

enum AlertType: Int {
    case noContent
    case comingSoon

    var title: String? {
        switch self {
        case .noContent: return R.string.localized.alertTitleNoContent()
        default: return nil
        }
    }

    var message: String? {
        switch self {
        case .noContent: return R.string.localized.alertMessageNoContent()
        case .comingSoon: return R.string.localized.alertMessageComingSoon()
        }
    }

    var buttonTitleCancel: String? {
        switch self {
        default: return nil
        }
    }

    var buttonTitleDefault: String? {
        switch self {
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
        default: return [.default]
        }
    }

    var alertStyle: UIAlertControllerStyle {
        switch self {
        default: return .alert
        }
    }
}

extension UIViewController {

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
        case .cancel:		alertController.addAction(UIViewController.cancelAction(type: type))
        case .default:		alertController.addAction(UIViewController.defaultAction(type: type, handler: handler))
        case .destructive:	alertController.addAction(UIViewController.destructiveAction(type: type, handler: handlerDestructive))
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

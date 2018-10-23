//
//  MyToBeVisionRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 20/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import MessageUI
import MBProgressHUD

final class MyToBeVisionRouter: NSObject {

    private let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showAlert(_ alert: AlertType) {
        viewController.showAlert(type: alert)
    }

    func showProgressHUD(_ message: String?) {
        guard let window = AppDelegate.current.window else { return }
        MBProgressHUD.showAdded(to: window, animated: true)
    }

    func hideProgressHUD() {
        guard let window = AppDelegate.current.window else { return }
        MBProgressHUD.hide(for: window, animated: true)
    }
}

extension MyToBeVisionRouter: MyToBeVisionRouterInterface {

    func close() {
        viewController.dismiss(animated: true, completion: nil)
    }

    func showMailComposer(email: String, subject: String, messageBody: String) {
        guard MFMailComposeViewController.canSendMail() == true else {
            viewController.showAlert(type: .message(R.string.localized.alertMessageEmailNotSetup()))
            return
        }
        let composer = MFMailComposeViewController()
        composer.setToRecipients([email])
        composer.setSubject(subject)
        composer.setMessageBody(messageBody, isHTML: true)
        composer.mailComposeDelegate = self.viewController
        viewController.present(composer, animated: true, completion: nil)
    }
}

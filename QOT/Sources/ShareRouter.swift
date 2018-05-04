//
//  ShareRouter.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import MessageUI

final class ShareRouter: NSObject, ShareRouterInterface {

    private let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }

    func dismiss() {
        viewController.dismiss(animated: true, completion: nil)
    }

    func showMailComposer(email: String, subject: String, messageBody: String) {
        guard MFMailComposeViewController.canSendMail() == true else {
            showAlert(.message("Email is not setup on your device"))
            return
        }

        let composer = MFMailComposeViewController()
        composer.setToRecipients([email])
        composer.setSubject(subject)
        composer.setMessageBody(messageBody, isHTML: true)
        composer.mailComposeDelegate = self
        viewController.present(composer, animated: true, completion: nil)
    }

    func showAlert(_ alert: AlertType) {
        viewController.showAlert(type: alert)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension ShareRouter: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        if let error = error {
            showAlert(.message(error.localizedDescription))
            log("Failed to open mail with error: \(error.localizedDescription))", level: .error)
        }
    }
}

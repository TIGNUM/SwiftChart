//
//  PartnersRouter.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import MessageUI

final class PartnersRouter: NSObject, PartnersRouterInterface {

    private let viewController: PartnersViewController

    init(viewController: PartnersViewController) {
        self.viewController = viewController
        super.init()
    }

    func showAlert(_ alert: AlertType) {
        viewController.showAlert(type: alert)
    }

    func showAlert(_ alert: UIAlertController) {
        viewController.present(alert, animated: true)
    }

    func showShare(partner: Partners.Partner) {
        guard let name = partner.name, let email = partner.email else {
            assertionFailure("partner must have name and email if this method is called")
            return
        }
        let configurator = ShareConfigurator.make(partnerLocalID: partner.localID,
                                                  partnerName: name,
                                                  partnerImageURL: partner.imageURL,
                                                  partnerInitials: partner.initials,
                                                  partnerEmail: email)
        let shareViewController = ShareViewController(configure: configurator)
        let navController = UINavigationController(rootViewController: shareViewController)
        navController.navigationBar.applyDefaultStyle()
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .custom
        viewController.present(navController, animated: true, completion: nil)
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
}

// MARK: - MFMailComposeViewControllerDelegate

extension PartnersRouter: MFMailComposeViewControllerDelegate {

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

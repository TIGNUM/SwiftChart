//
//  UIViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 05.11.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import MessageUI
import qot_dal

extension UIViewController {
    func isModal() -> Bool {
        return self.presentingViewController?.presentedViewController == self
            || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
            || self.tabBarController?.presentingViewController is UITabBarController
    }

    static func presentMailComposer(from viewController: UIViewController,
                                    recipients: [String],
                                    subject: String) {
        guard MFMailComposeViewController.canSendMail() == true else {
            viewController.showAlert(type: .message(AppTextService.get(AppTextKey.my_qot_my_profile_support_alert_email_try_again_body)))
            return
        }
        let composer = MFMailComposeViewController()
        composer.setToRecipients(recipients)
        composer.setSubject(subject)
        composer.mailComposeDelegate = viewController
        viewController.present(composer, animated: true, completion: nil)
    }
}

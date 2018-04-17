//
//  UIViewController+MFMailCompose.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 11/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import MessageUI

extension UIViewController: MFMailComposeViewControllerDelegate {

    public func mailComposeController(_ controller: MFMailComposeViewController,
                                      didFinishWith result: MFMailComposeResult,
                                      error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        if let error = error {
            showAlert(type: .message(error.localizedDescription))
        }
    }
}


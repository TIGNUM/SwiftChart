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

//    func setCustomBackButton() {
//        let backButton = UIBarButtonItem(image: R.image.ic_close_accent(),
//                                                           style: .plain,
//                                                           target: self,
//                                                           action: #selector(backToPreviousViewController))
//        navigationItem.leftBarButtonItem = backButton
//    }
//
//    func setCustomBackButtonTools() {
//        let backButtonTools = UIBarButtonItem(image: R.image.arrowBack(),
//                                         style: .plain,
//                                         target: self,
//                                         action: #selector(backToPreviousViewController))
//        backButtonTools.tintColor = .accent
//        backButtonTools.imageInsets = UIEdgeInsets(top: -30, left: 0, bottom: 30, right: 0)
//        navigationItem.leftBarButtonItem = backButtonTools
//        navigationItem.leftBarButtonItem?.setBackgroundVerticalPositionAdjustment(100.0, for: .default)
//        navigationItem.leftBarButtonItem?.setBackButtonBackgroundVerticalPositionAdjustment(-100, for: .default)
//        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: -30, left: 50, bottom: 30, right: -50)
//    }
//
//    func setCustomBackButtonSearch() {
//        let backButtonItem = UIBarButtonItem(image: R.image.ic_cancel(),
//                                             style: .plain,
//                                             target: self,
//                                             action: #selector(backToPreviousViewController))
//        backButtonItem.tintColor = .accent
//        navigationItem.rightBarButtonItem = backButtonItem
//    }
//
//    @objc func backToPreviousViewController() {
//        if let previousVC = navigationController?.viewControllers.dropLast().last {
//            navigationController?.popToViewController(previousVC, animated: true)
//        }
//    }
//
//    func attachToEdge(_ subview: UIView, bottomConstant: CGFloat) {
//        view.addSubview(subview)
//        subview.translatesAutoresizingMaskIntoConstraints = false
//        subview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        subview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomConstant).isActive = true
//        subview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        subview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//    }

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

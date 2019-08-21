//
//  MyToBeVisionRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 20/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import MessageUI
import SVProgressHUD

final class MyToBeVisionRouter: NSObject {

    private let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showAlert(_ alert: AlertType) {
        viewController.showAlert(type: alert)
    }

    func showProgressHUD(_ message: String?) {
        SVProgressHUD.show()
    }

    func hideProgressHUD() {
        SVProgressHUD.dismiss()
    }
}

extension MyToBeVisionRouter: MyToBeVisionRouterInterface {
    func showShareController(body: String) {
        let activityVC = UIActivityViewController(activityItems: [body], applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.openInIBooks,
                                            UIActivityType.airDrop,
                                            UIActivityType.postToTencentWeibo,
                                            UIActivityType.postToVimeo,
                                            UIActivityType.postToFlickr,
                                            UIActivityType.addToReadingList,
                                            UIActivityType.saveToCameraRoll,
                                            UIActivityType.assignToContact,
                                            UIActivityType.postToFacebook,
                                            UIActivityType.postToTwitter]
        viewController.present(activityVC, animated: true, completion: nil)
    }

    func close() {
        viewController.dismiss(animated: true, completion: nil)
    }
}

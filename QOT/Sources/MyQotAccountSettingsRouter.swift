//
//  MyQotAccountSettingsRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 08.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import SVProgressHUD

final class MyQotAccountSettingsRouter {

    // MARK: - Properties

    private weak var viewController: MyQotAccountSettingsViewController?

    // MARK: - Init

    init(viewController: MyQotAccountSettingsViewController) {
        self.viewController = viewController
    }
}

// MARK: - MyQotRouterInterface

extension MyQotAccountSettingsRouter: MyQotAccountSettingsRouterInterface {
    func showAlert(_ type: AlertType) {
        viewController?.showAlert(type: type)
    }

    func showProgressHUD() {
        SVProgressHUD.show()
    }

    func hideProgressHUD() {
        SVProgressHUD.dismiss()
    }

    func presentEditAccountSettings() {
        viewController?.performSegue(withIdentifier: R.segue.myQotAccountSettingsViewController.myQotAccountSettingsEditAccountSegueIdentifier, sender: nil)
    }
}

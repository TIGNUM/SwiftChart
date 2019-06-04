//
//  MyQotAccountSettingsRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 08.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import MBProgressHUD

final class MyQotAccountSettingsRouter {
    
    // MARK: - Properties
    
    private let viewController: MyQotAccountSettingsViewController
    
    // MARK: - Init
    
    init(viewController: MyQotAccountSettingsViewController) {
        self.viewController = viewController
    }
}


// MARK: - MyQotRouterInterface

extension MyQotAccountSettingsRouter: MyQotAccountSettingsRouterInterface {
    func showAlert(_ type: AlertType) {
        viewController.showAlert(type: type)
    }
    
    func showProgressHUD() {
        guard let window = AppDelegate.current.window else { return }
        MBProgressHUD.showAdded(to: window, animated: true)
    }
    
    func hideProgressHUD() {
        guard let window = AppDelegate.current.window else { return }
        MBProgressHUD.hide(for: window, animated: true)
    }
    
    func presentEditAccountSettings() {
        viewController.performSegue(withIdentifier: R.segue.myQotAccountSettingsViewController.myQotAccountSettingsEditAccountSegueIdentifier , sender: nil)
    }
}

//
//  MyQotAccountSettingsPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 08.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAccountSettingsPresenter {
    
    // MARK: - Properties
    
    private weak var viewController: MyQotAccountSettingsViewControllerInterface?
    
    // MARK: - Init
    
    init(viewController: MyQotAccountSettingsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MyQotInterface

extension MyQotAccountSettingsPresenter: MyQotAccountSettingsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
    
    func showResetPasswordAlert() {
        viewController?.showResetPasswordAlert()
    }

    func showLogoutAlert() {
        viewController?.showLogoutAlert()
    }
}

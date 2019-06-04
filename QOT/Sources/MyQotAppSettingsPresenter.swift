//
//  MyQotAppSettingsPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation


final class MyQotAppSettingsPresenter {
    // MARK: - Properties
    
    private weak var viewController: MyQotAppSettingsViewControllerInterface?
    
    // MARK: - Init
    
    init(viewController: MyQotAppSettingsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MyQotAppSettingsPresenterInterface

extension MyQotAppSettingsPresenter: MyQotAppSettingsPresenterInterface {
    func present(_ settings: MyQotAppSettingsModel) {
        viewController?.setup(settings)
    }
}

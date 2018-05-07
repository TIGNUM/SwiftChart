//
//  PermissionsPresenter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 30/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class PermissionsPresenter {

    private weak var viewController: PermissionsViewControllerInterface?

    init(viewController: PermissionsViewControllerInterface) {
        self.viewController = viewController
    }
}

extension PermissionsPresenter: PermissionsPresenterInterface {

    func load(_ permissions: [Permission]) {
        viewController?.setup(permissions)
    }
}

//
//  MyQOTAdminEditSprintsDetailsRouter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQOTAdminEditSprintsDetailsRouter {

    // MARK: - Properties
    private weak var viewController: MyQOTAdminEditSprintsDetailsViewController?

    // MARK: - Init
    init(viewController: MyQOTAdminEditSprintsDetailsViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MyQOTAdminEditSprintsDetailsRouterInterface
extension MyQOTAdminEditSprintsDetailsRouter: MyQOTAdminEditSprintsDetailsRouterInterface {
    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

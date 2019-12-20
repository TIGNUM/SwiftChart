//
//  MyQOTAdminEditSprintsRouter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQOTAdminEditSprintsRouter {

    // MARK: - Properties
    private weak var viewController: MyQOTAdminEditSprintsViewController?

    // MARK: - Init
    init(viewController: MyQOTAdminEditSprintsViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MyQOTAdminEditSprintsRouterInterface
extension MyQOTAdminEditSprintsRouter: MyQOTAdminEditSprintsRouterInterface {
    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    func openSprintDetails(for sprint: QDMSprint) {
        guard let sprintDetailsViewController = R.storyboard.myQot.myQotAdminEditSprintsDetailsID() else { return }
        MyQOTAdminEditSprintsDetailsConfigurator.configure(sprint, sprintDetailsViewController)
        viewController?.navigationController?.pushViewController(sprintDetailsViewController,
                                                                 animated: true)
    }
}

//
//  MyQOTAdminEditSprintsDetailsConfigurator.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQOTAdminEditSprintsDetailsConfigurator {
    static func configure(_ sprint: QDMSprint,
                          _ viewController: MyQOTAdminEditSprintsDetailsViewController) {
        let presenter = MyQOTAdminEditSprintsDetailsPresenter(viewController: viewController)
        let interactor = MyQOTAdminEditSprintsDetailsInteractor(presenter: presenter, sprint: sprint)
        viewController.interactor = interactor
    }
}

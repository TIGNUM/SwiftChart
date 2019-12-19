//
//  MyQOTAdminEditSprintsDetailsInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQOTAdminEditSprintsDetailsViewControllerInterface: class {
    func setupView()
}

protocol MyQOTAdminEditSprintsDetailsPresenterInterface {
    func setupView()
}

protocol MyQOTAdminEditSprintsDetailsInteractorInterface: Interactor {
    func getHeaderTitle() -> String
    func getDoneButtonTitle() -> String
    func getDatasourceCount() -> Int
}

protocol MyQOTAdminEditSprintsDetailsRouterInterface {
    func dismiss()
}

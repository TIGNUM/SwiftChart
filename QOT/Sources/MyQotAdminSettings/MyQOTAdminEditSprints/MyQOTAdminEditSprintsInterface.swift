//
//  MyQOTAdminEditSprintsInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MyQOTAdminEditSprintsViewControllerInterface: class {
    func setupView()
}

protocol MyQOTAdminEditSprintsPresenterInterface {
    func setupView()
}

protocol MyQOTAdminEditSprintsInteractorInterface: Interactor {
    func getHeaderTitle() -> String
    func getDatasourceCount() -> Int
    func getSprint(at index: Int) -> QDMSprint
}

protocol MyQOTAdminEditSprintsRouterInterface {
    func dismiss()
}

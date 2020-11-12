//
//  BaseDailyBriefDetailsInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 09/11/2020.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol BaseDailyBriefDetailsViewControllerInterface: class {
    func setupView()
}

protocol BaseDailyBriefDetailsPresenterInterface {
    func setupView()
}

protocol BaseDailyBriefDetailsInteractorInterface: Interactor {
    func getModel() -> BaseDailyBriefViewModel
}

protocol BaseDailyBriefDetailsRouterInterface {
    func dismiss()
}

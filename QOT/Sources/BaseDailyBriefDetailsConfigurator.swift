//
//  BaseDailyBriefDetailsConfigurator.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 09/11/2020.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

final class BaseDailyBriefDetailsConfigurator {
    static func configure(model: BaseDailyBriefViewModel, viewController: BaseDailyBriefDetailsViewController) {
        let router = BaseDailyBriefDetailsRouter(viewController: viewController)
        let worker = BaseDailyBriefDetailsWorker(model: model)
        let presenter = BaseDailyBriefDetailsPresenter(viewController: viewController)
        let interactor = BaseDailyBriefDetailsInteractor(presenter: presenter, model: model)

        viewController.interactor = interactor
    }
}

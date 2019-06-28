//
//  GoodToKnowConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 25.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class GoodToKnowConfigurator {

    static func make(viewController: GoodToKnowViewController?) {
        guard let viewController = viewController else { return }
        let router = GoodToKnowRouter(viewController: viewController)
        let worker = GoodToKnowWorker()
        let presenter = GoodToKnowPresenter(viewController: viewController)
        let interactor = GoodToKnowInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}

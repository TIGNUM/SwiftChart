//
//  ThoughtsConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class ThoughtsConfigurator {

    static func make(viewController: ThoughtsViewController?) {
        guard let viewController = viewController else { return }
        let router = ThoughtsRouter(viewController: viewController)
        let worker = ThoughtsWorker()
        let presenter = ThoughtsPresenter(viewController: viewController)
        let interactor = ThoughtsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}

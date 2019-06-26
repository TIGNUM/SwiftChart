//
//  QuestionConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 21.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class QuestionConfigurator {

    static func make(viewController: QuestionViewController?) {
        guard let viewController = viewController else { return }
        let router = QuestionRouter(viewController: viewController)
        let worker = QuestionWorker()
        let presenter = QuestionPresenter(viewController: viewController)
        let interactor = QuestionInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}

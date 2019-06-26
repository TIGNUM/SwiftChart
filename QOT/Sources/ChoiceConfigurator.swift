//
//  ChoiceConfigurator.swift
//  QOT
//
//  Created by karmic on 21.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class ChoiceConfigurator {
    static func make(_ selectedIds: [Int], _ relatedId: Int) -> (ChoiceViewController) -> Void {
        return { (viewController) in
            let router = ChoiceRouter(viewController: viewController)
            let worker = ChoiceWorker(selectedIds: selectedIds, relatedId: relatedId)
            let presenter = ChoicePresenter(viewController: viewController)
            let interactor = ChoiceInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
            interactor.generateItems()
        }
    }
}

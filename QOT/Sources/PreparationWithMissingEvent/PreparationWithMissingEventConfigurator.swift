//
//  PreparationWithMissingEventConfigurator.swift
//  QOT
//
//  Created by Sanggeon Park on 18.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class PreparationWithMissingEventConfigurator {

    static func make(_ preparations: [QDMUserPreparation]) -> (PreparationWithMissingEventViewController) -> Void {
        return { (viewController) in
            let router = PreparationWithMissingEventRouter(viewController: viewController)
            let worker = PreparationWithMissingEventWorker(preparations: preparations)
            let presenter = PreparationWithMissingEventPresenter(viewController: viewController)
            let interactor = PreparationWithMissingEventInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}

//
//  ShifterResultConfigurator.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class ShifterResultConfigurator {
    static func make(mindsetShifter: QDMMindsetShifter?, canDelete: Bool) -> (ShifterResultViewController) -> Void {
        return { viewController in
            let router = ShifterResultRouter(viewController: viewController)
            let worker = ShifterResultWorker(mindsetShifter, canDelete: canDelete)
            let presenter = ShifterResultPresenter(viewController: viewController)
            let interactor = ShifterResultInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}

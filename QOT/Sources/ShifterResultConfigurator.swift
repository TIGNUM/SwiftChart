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
    static func make(mindsetShifter: QDMMindsetShifter?, resultType: ResultType) -> (ShifterResultViewController) -> Void {
        return { viewController in
            let worker = ShifterResultWorker(mindsetShifter, resultType: resultType)
            let presenter = ShifterResultPresenter(viewController: viewController)
            let interactor = ShifterResultInteractor(worker: worker, presenter: presenter)
            viewController.interactor = interactor
        }
    }
}

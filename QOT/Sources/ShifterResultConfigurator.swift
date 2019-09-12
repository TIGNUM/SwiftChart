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
//    static func make(resultItem: MindsetResult.Item) -> (ShifterResultViewController) -> Void {
//        return { viewController in
//            let router = ShifterResultRouter(viewController: viewController)
//            let worker = ShifterResultWorker(resultItem)
//            let presenter = ShifterResultPresenter(viewController: viewController)
//            let interactor = ShifterResultInteractor(worker: worker, presenter: presenter, router: router)
//            viewController.interactor = interactor
//        }
//    }

    static func make(mindsetShifter: QDMMindsetShifter?) -> (ShifterResultViewController) -> Void {
        return { viewController in
            let router = ShifterResultRouter(viewController: viewController)
            let worker = ShifterResultWorker(mindsetShifter)
            let presenter = ShifterResultPresenter(viewController: viewController)
            let interactor = ShifterResultInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}

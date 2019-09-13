//
//  DTShortTBVConfigurator.swift
//  QOT
//
//  Created by karmic on 10.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class DTShortTBVConfigurator {
    static func make(introKey: String, delegate: DTMindsetInteractorInterface?) -> (DTShortTBVViewController) -> Void {
        return { (viewController) in
            let router = DTShortTBVRouter(viewController: viewController)
            let presenter = DTShortTBVPresenter(viewController: viewController)
            let interactor = DTShortTBVInteractor(presenter,
                                                  questionGroup: .MindsetShifterToBeVision,
                                                  introKey: introKey)
            viewController.shortTBVInteractor = interactor
            viewController.shortTBVRouter = router
            viewController.interactor = interactor
            viewController.router = router
            viewController.delegate = delegate
        }
    }
}

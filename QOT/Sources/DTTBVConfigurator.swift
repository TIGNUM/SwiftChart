//
//  DTTBVConfigurator.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class DTTBVConfigurator {
    static func make(delegate: MyVisionViewControllerScrollViewDelegate?) -> (DTTBVViewController) -> Void {
        return { (viewController) in
            let router = DTTBVRouter(viewController: viewController)
            let presenter = DTTBVPresenter(viewController: viewController)
            let interactor = DTTBVInteractor(presenter,
                                             questionGroup: .ToBeVision_3_0,
                                             introKey: TBV.QuestionKey.Instructions)
            viewController.interactor = interactor
            viewController.router = router
            viewController.tbvInteractor = interactor
            viewController.tbvRouter = router
            router.delegate = delegate
        }
    }
}

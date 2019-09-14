//
//  DTPrepareConfigurator.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class DTPrepareConfigurator {
    static func make() -> (DTPrepareViewController) -> Void {
        return { (viewController) in
            let router = DTPrepareRouter(viewController: viewController)
            let presenter = DTPreparePresenter(viewController: viewController)
            let interactor = DTPrepareInteractor(presenter,
                                                 questionGroup: .Prepare_3_0,
                                                 introKey: Prepare.QuestionKey.Intro)
            router.prepareViewController = viewController
            presenter.prepareViewController = viewController
            interactor.preparePresenter = presenter
            viewController.interactor = interactor
            viewController.prepareRouter = router
        }
    }
}

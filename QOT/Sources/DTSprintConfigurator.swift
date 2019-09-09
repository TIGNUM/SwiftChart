//
//  DTSprintConfigurator.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class DTSprintConfigurator {
    static func make() -> (DTSprintViewController) -> Void {
        return { (viewController) in
            let router = DTSprintRouter(viewController: viewController)
            let presenter = DTSprintPresenter(viewController: viewController)
            let interactor = DTSprintInteractor(presenter: presenter)
            viewController.interactor = interactor
            viewController.router = router
        }
    }
}

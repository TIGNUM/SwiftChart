//
//  CoachMarksConfigurator.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class CoachMarksConfigurator {
    static func make() -> (CoachMarksViewController) -> Void {
        return { (viewController) in
            let router = CoachMarksRouter(viewController: viewController)
            let presenter = CoachMarksPresenter(viewController: viewController)
            let interactor = CoachMarksInteractor(presenter: presenter)
            viewController.interactor = interactor
            viewController.router = router
        }
    }
}

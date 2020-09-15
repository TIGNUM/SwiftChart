//
//  TeamToBeVisionOptionsConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

final class TeamToBeVisionOptionsConfigurator {
    static func make() -> (TeamToBeVisionOptionsViewController) -> Void {
        return { (viewController) in
            let presenter = TeamToBeVisionOptionsPresenter(viewController: viewController)
            let interactor = TeamToBeVisionOptionsInteractor(presenter: presenter)
            viewController.interactor = interactor
        }
    }
}

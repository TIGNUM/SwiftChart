//
//  TeamVisionTrackerDetailsConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

final class TeamVisionTrackerDetailsConfigurator {
    static func make() -> (TeamVisionTrackerDetailsViewController) -> Void {
        return { (viewController) in
            let presenter = TeamVisionTrackerDetailsPresenter(viewController: viewController)
            let interactor = TeamVisionTrackerDetailsInteractor(presenter: presenter)
            viewController.interactor = interactor
        }
    }
}

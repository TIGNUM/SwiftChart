//
//  VisionRatingExplanationConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.08.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

final class VisionRatingExplanationConfigurator {
    static func make() -> (VisionRatingExplanationViewController) -> Void {
        return { (viewController) in
            let presenter = VisionRatingExplanationPresenter(viewController: viewController)
            let interactor = VisionRatingExplanationInteractor(presenter: presenter)
            viewController.interactor = interactor
        }
    }
}

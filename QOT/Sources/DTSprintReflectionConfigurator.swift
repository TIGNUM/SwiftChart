//
//  DTSprintReflectionConfigurator.swift
//  QOT
//
//  Created by Michael Karbe on 17.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class DTSprintReflectionConfigurator {
    static func make(sprint: QDMSprint) -> (DTSprintReflectionViewController) -> Void {
        return { (viewController) in
            let presenter = DTSprintReflectionPresenter(viewController: viewController)
            let interactor = DTSprintReflectionInteractor(presenter,
                                                          questionGroup: .SprintPostReflection,
                                                          introKey: SprintReflection.QuestionKey.Intro)
            interactor.sprintRefelctionPresenter = presenter
            interactor.sprint = sprint
            viewController.interactor = interactor
        }
    }
}

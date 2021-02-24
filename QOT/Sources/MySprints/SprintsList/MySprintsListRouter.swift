//
//  MySprintsListRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MySprintsListRouter {

    // MARK: - Properties

    private weak var viewController: MySprintsListViewController?

    // MARK: - Init

    init(viewController: MySprintsListViewController) {
        self.viewController = viewController
    }
}

// MARK: - MySprintsListRouterInterface

extension MySprintsListRouter: MySprintsListRouterInterface {
    func presentSprint(_ sprint: QDMSprint) {
        guard let sprintDetailsController = R.storyboard.mySprintDetails.mySprintDetailsViewController() else {
            return
        }
        let configurator = MySprintDetailsConfigurator.make(sprintId: sprint.qotId ?? String.empty)
        configurator(sprintDetailsController)
        viewController?.present(sprintDetailsController, animated: true)
    }

    func presentAddSprint() {
        let configurator = DTSprintConfigurator.make(isPresentedFromCoach: false)
        let controller = DTSprintViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }
}

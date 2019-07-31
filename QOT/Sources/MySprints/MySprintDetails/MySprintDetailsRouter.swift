//
//  MySprintDetailsRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MySprintDetailsRouter {

    // MARK: - Properties

    private let viewController: MySprintDetailsViewController

    // MARK: - Init

    init(viewController: MySprintDetailsViewController) {
        self.viewController = viewController
    }
}

// MARK: - MySprintDetailsRouterInterface

extension MySprintDetailsRouter: MySprintDetailsRouterInterface {
    func presentTakeawayCapture(for sprint: QDMSprint) {
        let configurator = DecisionTreeConfigurator.make(for: .sprintReflection(sprint: sprint))
        let controller = DecisionTreeViewController(configure: configurator)
        viewController.present(controller, animated: true)
    }
}

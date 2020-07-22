//
//  TeamToBeVisionRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamToBeVisionRouter {

    // MARK: - Properties
    private weak var viewController: TeamToBeVisionViewController?

    // MARK: - Init
    init(viewController: TeamToBeVisionViewController?) {
        self.viewController = viewController
    }
}

// MARK: - TeamToBeVisionRouterInterface
extension TeamToBeVisionRouter: TeamToBeVisionRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func showEditVision(title: String, vision: String, isFromNullState: Bool, team: QDMTeam?) {
        guard
            let controller = R.storyboard.myToBeVision.myVisionEditDetailsViewController(),
            let visionController = self.viewController else { return }
        MyVisionEditDetailsConfigurator.configure(viewController: controller,
                                                  title: title,
                                                  vision: vision,
                                                  isFromNullState: isFromNullState,
                                                  team: team)
        visionController.present(controller, animated: true, completion: nil)
    }
}

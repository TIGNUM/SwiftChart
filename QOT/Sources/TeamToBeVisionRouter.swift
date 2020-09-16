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

    func showAlert(type: AlertType, handler: (() -> Void)?, handlerDestructive: (() -> Void)?) {
        viewController?.showAlert(type: type, handler: handler, handlerDestructive: handlerDestructive)
    }

    func showViewController(viewController: UIViewController, completion: (() -> Void)?) {
        self.viewController?.present(viewController, animated: true, completion: completion)
    }

    func showRatingExplanation(team: QDMTeam?) {
        let controller = R.storyboard.visionRatingExplanation.visionRatingExplanationViewController()
        if let controller = controller {
            let type: Explanation.Types = (team?.thisUserIsOwner == true) ? .ratingOwner : .ratingUser
            showRating(team, type, controller)
        }
    }

    func showTbvPollEXplanation(team: QDMTeam?) {
        let controller = R.storyboard.visionRatingExplanation.visionRatingExplanationViewController()
        if let controller = controller {
            let type: Explanation.Types = (team?.thisUserIsOwner == true) ? .tbvPollOwner : .tbvPollUser
            showRating(team, type, controller)
        }
    }

    //TEST

    func showOptionsPage(_ type: TeamToBeVisionOptionsModel.Types) {
        let controller = R.storyboard.teamToBeVisionOptions.teamToBeVisionOptionsViewController()
        if let controller = controller {
            let configurator = TeamToBeVisionOptionsConfigurator.make(type: type, remainingDays: 3)
            configurator(controller)
            viewController?.pushToStart(childViewController: controller)
        }
    }
}

// MARK: - Private
private extension TeamToBeVisionRouter {
    func showRating(_ team: QDMTeam?, _ type: Explanation.Types, _ controller: VisionRatingExplanationViewController) {
        let configurator = VisionRatingExplanationConfigurator.make(team: team, type: type)
        configurator(controller)
        viewController?.pushToStart(childViewController: controller)
    }
}

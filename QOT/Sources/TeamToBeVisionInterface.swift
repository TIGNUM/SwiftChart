//
//  TeamToBeVisionInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol TeamToBeVisionViewControllerInterface: class {
    func setupView()
    func showNullState(with title: String, message: String, header: String)
    func hideNullState()
    func setSelectionBarButtonItems()
    func load(_ teamVision: QDMTeamToBeVision?, rateText: String?, isRateEnabled: Bool)
    func updatePollButton(poll: ButtonTheme.Poll)
    func updateTrackerButton(poll: ButtonTheme.Poll)
}

protocol TeamToBeVisionPresenterInterface {
    func setupView()
    func showNullState(with title: String, teamName: String?, message: String)
    func hideNullState()
    func load(_ teamVision: QDMTeamToBeVision?, rateText: String?, isRateEnabled: Bool)
    func setSelectionBarButtonItems()
    func updatePoll(visionPoll: QDMTeamToBeVisionPoll?,
                    trackerPoll: QDMTeamToBeVisionTrackerPoll?,
                    team: QDMTeam?,
                    teamToBeVision: QDMTeamToBeVision?)
}

protocol TeamToBeVisionViewControllerScrollViewDelegate: class {
    func scrollToTop(_ animated: Bool)
}

protocol TeamToBeVisionInteractorInterface: Interactor {
    func showEditVision(isFromNullState: Bool)
    func showNullState()
    func hideNullState()
    func isShareBlocked(_ completion: @escaping (Bool) -> Void)
    func viewWillAppear()
    func saveToBeVision(image: UIImage?)

    var teamNullStateSubtitle: String? { get }
    var teamNullStateTitle: String? { get }
    var emptyTeamTBVTitlePlaceholder: String { get }
    var emptyTeamTBVTextPlaceholder: String { get }
    var team: QDMTeam { get }
    var nullStateCTA: String? { get }
    var shouldShowPollExplanation: Bool { get }
    var shouldShowPollAdmin: Bool { get }
    var teamVisionPoll: QDMTeamToBeVisionPoll? { get }

    func lastUpdatedTeamVision() -> String?
    func presentTrends()
    func shareTeamToBeVision()
    func ratingTapped()
    func isTrendsHidden(_ completion: @escaping (Bool) -> Void)
}

protocol TeamToBeVisionRouterInterface {
    func dismiss()
    func showEditVision(title: String, vision: String, isFromNullState: Bool, team: QDMTeam?)
    func showAlert(type: AlertType, handler: (() -> Void)?, handlerDestructive: (() -> Void)?)
    func showViewController(viewController: UIViewController, completion: (() -> Void)?)
    func showRatingExplanation(team: QDMTeam?)
    func showTbvPollEXplanation(team: QDMTeam?)
    func showAdminOptions(team: QDMTeam?, remainingDays: Int)
}

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
    func load(_ teamVision: QDMTeamToBeVision?,
              rateText: String?,
              isRateEnabled: Bool,
              shouldShowSingleMessageRating: Bool?)
}

protocol TeamToBeVisionPresenterInterface {
    func setupView()
    func showNullState(with title: String, teamName: String?, message: String)
    func hideNullState()
    func load(_ teamVision: QDMTeamToBeVision?,
              rateText: String?,
              isRateEnabled: Bool,
              shouldShowSingleMessageRating: Bool?)
    func setSelectionBarButtonItems()
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
    var team: QDMTeam? { get }
    var nullStateCTA: String? { get }
    func lastUpdatedTeamVision() -> String?
    func presentTrends()
    func shareTeamToBeVision()
}

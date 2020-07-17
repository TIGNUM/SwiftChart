//
//  MyVisionInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MyVisionViewControllerInterface: class {
    func showNullState(with title: String, message: String, writeMessage: String)
    func hideNullState()
    func setupView()
    func load(_ myVision: QDMToBeVision?, teamVision: QDMTeamToBeVision?, rateText: String?, isRateEnabled: Bool, shouldShowSingleMessageRating: Bool?)
    func presentTBVUpdateAlert(title: String, message: String, editTitle: String, createNewTitle: String)
}

protocol MyVisionViewControllerScrollViewDelegate: class {
    func scrollToTop(_ animated: Bool)
}

protocol MyVisionPresenterInterface {
    func showNullState(with title: String, message: String, writeMessage: String)
    func hideNullState()
    func setupView()
    func load(_ myVision: QDMToBeVision?, teamVision: QDMTeamToBeVision?, rateText: String?, isRateEnabled: Bool, shouldShowSingleMessageRating: Bool?)
    func presentTBVUpdateAlert(title: String, message: String, editTitle: String, crateNewTitle: String)
}

protocol MyVisionInteractorInterface: Interactor {
    var emptyTBVTextPlaceholder: String { get }
    var emptyTBVTitlePlaceholder: String { get }
    var emptyTeamTBVTextPlaceholder: String { get }
    var emptyTeamTBVTitlePlaceholder: String { get }
    var nullStateSubtitle: String? { get }
    var nullStateTitle: String? { get }
    var nullStateCTA: String? { get }
    var teamNullStateSubtitle: String? { get }
    var teamNullStateTitle: String? { get }
    var team: QDMTeam? { get }

    func showTracker()
    func showUpdateConfirmationScreen()
    func showNullState(with title: String, message: String, writeMessage: String)
    func showTBVData()
    func showEditVision(isFromNullState: Bool)
    func showRateScreen()

    func hideNullState()
    func saveToBeVision(image: UIImage?)
    func lastUpdatedVision() -> String?
    func shareToBeVision()

    func openToBeVisionGenerator()
    func viewWillAppear()
    func isShareBlocked(_ completion: @escaping (Bool) -> Void)
    func getToBeVision(_ completion: @escaping (QDMToBeVision?) -> Void)
    func shouldShowWarningIcon(_ completion: @escaping (Bool) -> Void)
}

protocol MyVisionRouterInterface {
    func showTracker()
    func showTBVData(shouldShowNullState: Bool, visionId: Int?)
    func showEditVision(title: String, vision: String, isFromNullState: Bool, team: QDMTeam?)
    func showRateScreen(with id: Int)
    func showViewController(viewController: UIViewController, completion: (() -> Void)?)
    func showTBVGenerator()
}

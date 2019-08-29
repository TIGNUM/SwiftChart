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
    func showScreenLoader()
    func hideScreenLoader()
    func showNullState(with title: String, message: String)
    func hideNullState()
    func setupView()
    func load(_ myVision: QDMToBeVision?, rateText: String?, isRateEnabled: Bool, shouldShowSingleMessage: Bool)
    func presentTBVUpdateAlert(title: String, message: String, editTitle: String, createNewTitle: String)
}

protocol MyVisionPresenterInterface {
    func showScreenLoader()
    func hideScreenLoader()
    func showNullState(with title: String, message: String)
    func hideNullState()
    func setupView()
    func load(_ myVision: QDMToBeVision?, rateText: String?, isRateEnabled: Bool, shouldShowSingleMessage: Bool)
    func presentTBVUpdateAlert(title: String, message: String, editTitle: String, crateNewTitle: String)
}

protocol MyVisionInteractorInterface: Interactor {
    func shouldShowWarningIcon() -> Bool
    func showTracker()
    func showUpdateConfirmationScreen()
    func showNullState(with title: String, message: String)
    func hideNullState()
    func saveToBeVision(image: UIImage?, toBeVision: QDMToBeVision)
    var myVision: QDMToBeVision? { get }
    var nullStateSubtitle: String? { get }
    var nullStateTitle: String? { get }
    func isShareBlocked() -> Bool
    func lastUpdatedVision() -> String?
    func shareMyToBeVision()
    func showTBVData()
    func showEditVision(isFromNullState: Bool)
    func openToBeVisionGenerator()
    func showRateScreen(with id: Int)
}

protocol MyVisionRouterInterface {
    func showTracker()
    func showTBVData(shouldShowNullState: Bool, visionId: Int?)
    func showEditVision(title: String, vision: String, isFromNullState: Bool)
    func showRateScreen(with id: Int)
    func presentViewController(viewController: UIViewController, completion: (() -> Void)?)
    func openToBeVisionGenerator()
}

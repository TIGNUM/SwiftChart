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
}

protocol MyVisionPresenterInterface {
    func showScreenLoader()
    func hideScreenLoader()
    func showNullState(with title: String, message: String)
    func hideNullState()
    func setupView()
    func load(_ myVision: QDMToBeVision?, rateText: String?, isRateEnabled: Bool, shouldShowSingleMessage: Bool)
}

protocol MyVisionInteractorInterface: Interactor {
    func shouldShowWarningIcon() -> Bool
    func showTracker()
    func closeUpdateConfirmationScreen(completion: (() -> Void)?)
    func showUpdateConfirmationScreen()
    func showNullState(with title: String, message: String)
    func hideNullState()
    func saveToBeVision(image: UIImage?, toBeVision: QDMToBeVision)
    var myVision: QDMToBeVision? { get }
    var headlinePlaceholder: String? { get }
    var messagePlaceholder: String? { get }
    func isShareBlocked() -> Bool
    func lastUpdatedVision() -> String?
    func shareMyToBeVision()
    func showTBVData()
    func showEditVision()
    func openToBeVisionGenerator()
    func showRateScreen(with id: Int)
}

protocol MyVisionRouterInterface {
    func showTracker()
    func showTBVData(shouldShowNullState: Bool, visionId: Int?)
    func showEditVision(title: String, vision: String)
    func closeUpdateConfirmationScreen(completion: (() -> Void)?)
    func showRateScreen(with id: Int)
    func showUpdateConfirmationScreen()
    func presentViewController(viewController: UIViewController, completion: (() -> Void)?)
    func openToBeVisionGenerator()
}

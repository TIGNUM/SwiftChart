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
    func load(_ myVision: QDMToBeVision?)
}

protocol MyVisionPresenterInterface {
    func showScreenLoader()
    func hideScreenLoader()
    func showNullState(with title: String, message: String)
    func hideNullState()
    func setupView()
    func load(_ myVision: QDMToBeVision?)
}

protocol MyVisionInteractorInterface: Interactor {
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
    func showEditVision()
    func openToBeVisionGenerator()
}

protocol MyVisionRouterInterface {
    func showUpdateConfirmationScreen()
    func presentViewController(viewController: UIViewController, completion: (() -> Void)?)
    func showEditVision()
    func close()
    func openToBeVisionGenerator()
}

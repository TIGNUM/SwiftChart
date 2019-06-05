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
    func setupView()
    func load(_ myVision: QDMToBeVision?)
}

protocol MyVisionPresenterInterface {
    func setupView()
    func load(_ myVision: QDMToBeVision?)
}

protocol MyVisionInteractorInterface: Interactor {
    func saveToBeVision(image: UIImage?, toBeVision: QDMToBeVision)
    var myVision: QDMToBeVision? { get }
    var permissionManager: PermissionsManager { get }
    var trackablePageObject: PageObject? { get }
    var headlinePlaceholder: String? { get }
    var messagePlaceholder: String? { get }
    func updateToBeVision()
    func isShareBlocked() -> Bool
    func lastUpdatedVision() -> String?
    func shareMyToBeVision()
    func showEditVision()
    func openToBeVisionGenerator()
}

protocol MyVisionRouterInterface {
    func presentViewController(viewController: UIViewController, completion: (() -> Void)?)
    func showEditVision()
    func close()
    func openToBeVisionGenerator(permissionManager: PermissionsManager)
}

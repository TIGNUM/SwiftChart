//
//  MyToBeVisionProtocols.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 20/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

protocol MyToBeVisionViewControllerInterface: class {
    func setup(with toBeVision: MyToBeVisionModel.Model)
    func update(with toBeVision: MyToBeVisionModel.Model)
    func displayImageError()
}

protocol MyToBeVisionPresenterInterface {
    func loadToBeVision(_ toBeVision: MyToBeVisionModel.Model)
    func updateToBeVision(_ toBeVision: MyToBeVisionModel.Model)
    func presentImageError(_ error: Error)
}

protocol MyToBeVisionInteractorInterface: Interactor {
    func saveToBeVision(toBeVision: MyToBeVisionModel.Model)
    func updateToBeVisionImage(image: UIImage, toBeVision: MyToBeVisionModel.Model)
    // FIXME: Think of better way of handling page tracking in VIP
    var trackablePageObject: PageObject? { get }
}

protocol MyToBeVisionRouterInterface {
    func close()
}

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
    func showVisionGenerator()
    func setLaunchOptions(_ options: [LaunchOption: String?])
    func setLoading(model: MyToBeVisionModel.Model?)
}

protocol MyToBeVisionPresenterInterface {
    func setLoading(model: MyToBeVisionModel.Model?)
    func loadToBeVision(_ toBeVision: MyToBeVisionModel.Model)
    func updateToBeVision(_ toBeVision: MyToBeVisionModel.Model)
    func presentVisionGenerator()
    func setLaunchOptions(_ options: [LaunchOption: String?])
}

protocol MyToBeVisionInteractorInterface: Interactor {
    func saveToBeVision(image: UIImage?, toBeVision: MyToBeVisionModel.Model)
    func makeVisionGeneratorAndPresent()
    func shareMyToBeVision(completion: @escaping (Error?) -> Void)
    func setLaunchOptions()
    func isReady() -> Bool

    // FIXME: Think of better way of handling page tracking in VIP
    var trackablePageObject: PageObject? { get }
    var visionChatItems: [VisionGeneratorChoice.QuestionType: [ChatItem<VisionGeneratorChoice>]] { get }
    var navigationItem: NavigationItem { get }
}

protocol MyToBeVisionRouterInterface {
    func close()
    func showMailComposer(email: String, subject: String, messageBody: String)
}

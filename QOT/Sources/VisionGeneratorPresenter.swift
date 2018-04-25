//
//  VisionGeneratorPresenter.swift
//  QOT
//
//  Created by karmic on 10.04.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class VisionGeneratorPresenter {

    private weak var viewController: ChatViewControllerInterface?
    private weak var visionController: MyToBeVisionViewController?

    init(viewController: ChatViewControllerInterface, visionController: MyToBeVisionViewController) {
        self.viewController = viewController
        self.visionController = visionController
    }
}

// MARK: - VisionGeneratorPresenterInterface

extension VisionGeneratorPresenter: VisionGeneratorPresenterInterface {

    func showLoadingIndicator() {
        viewController?.showLoadingIndicator()
    }

    func updateVisionControllerModel(_ model: MyToBeVisionModel.Model) {
        visionController?.update(with: model)
    }

    func dismiss() {
        viewController?.dismiss()
    }

    func updateBottomButton(_ choice: VisionGeneratorChoice, questionType: VisionGeneratorChoice.QuestionType) {
        viewController?.updateBottomButton(choice, questionType: questionType)
    }

    func showContent(_ contentID: Int, choice: VisionGeneratorChoice) {
        viewController?.showContent(contentID, choice: choice)
    }

    func showMedia(_ mediaURL: URL, choice: VisionGeneratorChoice) {
        viewController?.showMedia(mediaURL, choice: choice)
    }
}

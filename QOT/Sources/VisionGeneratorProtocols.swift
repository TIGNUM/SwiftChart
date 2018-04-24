//
//  VisionGeneratorProtocols.swift
//  QOT
//
//  Created by karmic on 10.04.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

protocol ChatViewControllerInterface: class {
    func showContent(_ contentID: Int, choice: VisionGeneratorChoice)
    func showMedia(_ mediaURL: URL, choice: VisionGeneratorChoice)
    func loadNextQuestions(_ choice: VisionGeneratorChoice)
    func laodLastQuestion()
    func updateBottomButton(_ choice: VisionGeneratorChoice, questionType: VisionGeneratorChoice.QuestionType)
    func resetVisionChoice()
    func dismiss()
}

protocol VisionGeneratorPresenterInterface {
    func showContent(_ contentID: Int, choice: VisionGeneratorChoice)
    func showMedia(_ mediaURL: URL, choice: VisionGeneratorChoice)
    func updateBottomButton(_ choice: VisionGeneratorChoice, questionType: VisionGeneratorChoice.QuestionType)
    func dismiss()
    func updateVisionControllerModel(_ model: MyToBeVisionModel.Model)
}

protocol VisionGeneratorInteractorInterface: Interactor {
    var visionSelectionCount: Int { get }
    func handleChoice(_ choice: VisionGeneratorChoice)
    func loadNextQuestions(_ choice: VisionGeneratorChoice)
    func laodLastQuestion()
    func didPressBottomButton(_ choice: VisionGeneratorChoice)
    func bottomButtonTitle(_ choice: VisionGeneratorChoice) -> String
}

protocol VisionGeneratorRouterInterface {
    func showPictureActionSheet(_ visionType: VisionGeneratorChoice.QuestionType)
    func loadLastQuestion()
}

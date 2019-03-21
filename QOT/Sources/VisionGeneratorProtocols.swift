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
    func showMedia(_ mediaURL: URL, choice: VisionGeneratorChoice, contentItem: ContentItem?)
    func loadNextQuestions(_ choice: VisionGeneratorChoice)
    func laodLastQuestion()
    func updateBottomButton(_ choice: VisionGeneratorChoice, questionType: VisionGeneratorChoice.QuestionType)
    func resetVisionChoice()
    func dismiss()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func restartGenerator()
}

protocol VisionGeneratorPresenterInterface {
    func showContent(_ contentID: Int, choice: VisionGeneratorChoice)
    func showMedia(_ mediaURL: URL, choice: VisionGeneratorChoice, contentItem: ContentItem?)
    func updateBottomButton(_ choice: VisionGeneratorChoice, questionType: VisionGeneratorChoice.QuestionType)
    func dismiss()
    func updateVisionControllerModel()
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

protocol VisionGeneratorInteractorInterface: Interactor {
    func visionSelectionCount(for questionType: VisionGeneratorChoice.QuestionType) -> Int
    func handleChoice(_ choice: VisionGeneratorChoice)
    func loadNextQuestions(_ choice: VisionGeneratorChoice)
    func laodLastQuestion()
    func didPressBottomButton(_ choice: VisionGeneratorChoice)
    func bottomButtonTitle(_ choice: VisionGeneratorChoice) -> String
    func restartGenerator()
    func saveVision()
    var currentQuestionType: VisionGeneratorChoice.QuestionType { get }
    var shouldShowAlertVisionNotSaved: Bool { get }
    var alertModel: VisionGeneratorAlertModel? { get }
}

protocol VisionGeneratorRouterInterface {
    func showPictureActionSheet(_ visionType: VisionGeneratorChoice.QuestionType)
    func loadLastQuestion()
}

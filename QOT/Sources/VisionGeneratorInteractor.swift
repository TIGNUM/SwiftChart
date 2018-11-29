//
//  VisionGeneratorInteractor.swift
//  QOT
//
//  Created by karmic on 10.04.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class VisionGeneratorInteractor {

    let worker: VisionGeneratorWorker
    let router: VisionGeneratorRouterInterface
    let presenter: VisionGeneratorPresenterInterface

    init(worker: VisionGeneratorWorker,
         router: VisionGeneratorRouterInterface,
         presenter: VisionGeneratorPresenterInterface) {
        self.worker = worker
        self.router = router
        self.presenter = presenter
    }
}

// MARK: - VisionGeneratorInteractor

extension VisionGeneratorInteractor: VisionGeneratorInteractorInterface {

    func restartGenerator() {
        worker.restartGenerator()
    }

    var currentQuestionType: VisionGeneratorChoice.QuestionType {
        return worker.questionType
    }

    func visionSelectionCount(for questionType: VisionGeneratorChoice.QuestionType) -> Int {
        return worker.visionSelectionCount(for: questionType)
    }

    func laodLastQuestion() {
        worker.updateViewModel(for: .review)
    }

    func bottomButtonTitle(_ choice: VisionGeneratorChoice) -> String {
        return worker.bottomButtonTitle(choice)
    }

    func didPressBottomButton(_ choice: VisionGeneratorChoice) {
        loadNextQuestions(choice)
    }

    func loadNextQuestions(_ choice: VisionGeneratorChoice) {
        worker.updateViewModel(for: choice.type.nextType)
        presenter.updateBottomButton(choice, questionType: worker.questionType)
    }

    func handleChoice(_ choice: VisionGeneratorChoice) {
        switch choice.type {
        case .intro,
             .instructions: handleChoiceTargets(choice)
        case .work,
             .home: handleChoiceDecision(choice)
        case .next:
            presenter.showLoadingIndicator()
            worker.saveVision { [weak self] in
                self?.presenter.hideLoadingIndicator()
                guard self?.worker.model != nil else { return }
                self?.presenter.updateVisionControllerModel()
                self?.handleChoiceTargets(choice)
            }
            // Set restart URL
            RestartHelper.setRestartURLScheme(.toBeVision, options: [.edit: "image"])
        case .picture:
            if choice.target == nil {
                router.showPictureActionSheet(.picture)
            } else {
                handleChoiceTargets(choice)
            }
        case .review:
            // Remove RestartInfo because we don't need it in this case.
            RestartHelper.clearRestartRouteInfo()
            presenter.showLoadingIndicator()
            worker.saveVision(completion: nil)
            if worker.model != nil {
                presenter.updateVisionControllerModel()
            }
            presenter.dismiss()
        default: return
        }
    }
}

// MARK: - Private

private extension VisionGeneratorInteractor {

    func handleChoiceDecision(_ choice: VisionGeneratorChoice) {
        presenter.updateBottomButton(choice, questionType: worker.questionType)
    }

    func handleChoiceTargets(_ choice: VisionGeneratorChoice) {
        guard let target = choice.target else { return }
        switch target {
        case .contentItem(let id): showContentItem(choice, contentItemID: id)
        case .content(let id): showContent(choice, contentID: id)
        case .question(let id): updateViewModel(choice, questionID: id)
        }
    }

    func updateViewModel(_ choice: VisionGeneratorChoice, questionID: Int) {
        let nextChatItems = worker.chatItems(for: questionID)
        worker.updateViewModel(with: nextChatItems)
        presenter.updateBottomButton(choice, questionType: worker.questionType)
    }

    func showContent(_ choice: VisionGeneratorChoice, contentID: Int) {
        presenter.showContent(contentID, choice: choice)
    }

    func showContentItem(_ choice: VisionGeneratorChoice, contentItemID: Int) {
        guard let url = worker.fetchMediaURL(contentItemID: contentItemID) else { return }
        presenter.showMedia(url, choice: choice)
    }
}

// MARK: - ImagePickerControllerDelegate

extension VisionGeneratorInteractor: ImagePickerControllerDelegate {

    func cancelSelection() {
        router.loadLastQuestion()
    }

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        do {
            try worker.saveImage(image)
        } catch {
            log("Error while saving TBV image: \(error.localizedDescription)")
        }
        router.loadLastQuestion()
        guard worker.model != nil else { return }
        presenter.updateVisionControllerModel()
    }
}

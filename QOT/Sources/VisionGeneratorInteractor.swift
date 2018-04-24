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

    var visionSelectionCount: Int {
        return worker.visionSelectionCount
    }
}

// MARK: - VisionGeneratorInteractor

extension VisionGeneratorInteractor: VisionGeneratorInteractorInterface {

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
             .instructions,
             .next: handleChoiceTargets(choice)
        case .work,
             .home: handleChoiceDecision(choice)
        case .picture:
            if choice.target == nil {
                router.showPictureActionSheet(.picture)
            } else {
                handleChoiceTargets(choice)
            }
        case .review:
            worker.saveVision()
            presenter.dismiss()
        default: return
        }
    }
}

// MARK: - Private

private extension VisionGeneratorInteractor {

    func handleChoiceDecision(_ choice: VisionGeneratorChoice) {
        worker.updateVisionSelections(choice)
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

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        do {
            try worker.saveImage(image)
        } catch {
            log("Error while saving TBV image: \(error.localizedDescription)")
        }
        router.loadLastQuestion()
        guard let model = worker.model else { return }
        presenter.updateVisionControllerModel(model)
    }
}

//
//  MyToBeVisionInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 20/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class MyToBeVisionInteractor: MyToBeVisionInteractorInterface {

    let presenter: MyToBeVisionPresenterInterface
    let worker: MyToBeVisionWorker

    init(presenter: MyToBeVisionPresenterInterface, worker: MyToBeVisionWorker) {
        self.worker = worker
        self.presenter = presenter
    }

    func viewDidLoad() {
        guard let toBeVision = worker.myToBeVision() else { return }
        presenter.loadToBeVision(toBeVision)
    }

    func headlinePlaceholderNeeded(headlineEdited: String) -> String? {
        if headlineEdited.isTrimmedTextEmpty == true {
            return worker.headlinePlaceholder
        }
        return headlineEdited
    }

    func messagePlaceholderNeeded(messageEdited: String) -> String? {
        if messageEdited.isTrimmedTextEmpty == true {
            return worker.messagePlaceholder
        }
        return messageEdited
    }

    func saveToBeVision(toBeVision: MyToBeVisionModel.Model) {
        worker.updateMyToBeVision(toBeVision)
    }

    func updateToBeVisionImage(image: UIImage, toBeVision: MyToBeVisionModel.Model) {
        do {
            var vision = toBeVision
            vision.imageURL = try worker.saveImage(image)
            vision.lastUpdated = Date()
            presenter.updateToBeVision(vision)
        } catch {
            presenter.presentImageError(error)
        }
    }

    var trackablePageObject: PageObject? {
        return worker.trackablePageObject
    }

    var visionChatItems: [VisionGeneratorChoice.QuestionType: [ChatItem<VisionGeneratorChoice>]] {
        return worker.visionChatItems
    }
}

// MARK: - Vision Generator

extension MyToBeVisionInteractor {

    func makeVisionGeneratorAndPresent() {
        presenter.presentVisionGenerator()
    }
}

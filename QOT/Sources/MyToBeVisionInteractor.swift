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
        worker.setMyToBeVisionReminder(false)
        guard let toBeVision = worker.myToBeVision() else { return }
        presenter.loadToBeVision(toBeVision)
    }

    func isEmptyState() -> Bool {
        let myToBeVision = worker.myToBeVision()
        return myToBeVision?.headLine == nil && myToBeVision?.text == nil
    }

    func messageEqualsPlaceholder(message: String) -> Bool {
        return message == worker.messagePlaceholder
    }

    func headlinePlaceholderNeeded(headlineEdited: String) -> String? {
        if headlineEdited.isTrimmedTextEmpty == true {
            return worker.headlinePlaceholder
        }
        return headlineEdited.uppercased()
    }

    func messagePlaceholderNeeded(messageEdited: String) -> String? {
        if messageEdited.isTrimmedTextEmpty == true {
            return worker.messagePlaceholder
        }
        return messageEdited
    }

    func saveToBeVision(image: UIImage?, toBeVision: MyToBeVisionModel.Model) {
        do {
            var vision = toBeVision
            if let visionImage = image {
                vision.imageURL = try worker.saveImage(visionImage)
            }
            worker.updateMyToBeVision(vision)
            presenter.updateToBeVision(vision)
        } catch {
            log(error.localizedDescription)
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

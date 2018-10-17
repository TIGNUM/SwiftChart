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
    let router: MyToBeVisionRouter
    let options: [LaunchOption: String?]

    init(presenter: MyToBeVisionPresenterInterface,
         worker: MyToBeVisionWorker,
         router: MyToBeVisionRouter,
         options: [LaunchOption: String?]?) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.options = options ?? [:]
    }

    func viewDidLoad() {
        worker.setMyToBeVisionReminder(false)
        guard let toBeVision = worker.myToBeVision() else { return }
        presenter.loadToBeVision(toBeVision)
    }

    func setLaunchOptions() {
        presenter.setLaunchOptions(options)
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

extension MyToBeVisionInteractor: AppStateAccess {
    func shareMyToBeVision(completion: @escaping (Error?) -> Void) {
        self.router.showProgressHUD(nil)
        let networkManager = MyToBeVisionInteractor.appState.networkManager
        networkManager?.performPartnerSharingRequest(partnerID: 0,
                                                    sharingType: Partners.SharingType.toBeVision) { result in
            switch result {
            case .success(let value):
                self.router.showMailComposer(email: "", subject: value.subject, messageBody: value.body)
                completion(nil)
            case .failure(let error):
                completion(error)
            }
            self.router.hideProgressHUD()
        }
    }
}

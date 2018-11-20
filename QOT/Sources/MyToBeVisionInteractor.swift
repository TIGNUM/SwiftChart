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
        self.worker.toBeVisionDidChange = { [unowned self] (model: MyToBeVisionModel.Model?) in
            self.presenter.setLoading()
        }
    }

    func viewDidLoad() {
        worker.setMyToBeVisionReminder(false)
        guard nil != worker.myToBeVision() else { return }
        worker.updateWidget()
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

    func isShareBlocked() -> Bool {
        let vision = worker.myToBeVision()
        let visionIsNil = vision?.headLine == nil && vision?.text == nil
        let visionIsDefault = vision?.text == worker.messagePlaceholder
        return visionIsNil || visionIsDefault
    }

    func saveToBeVision(image: UIImage?, toBeVision: MyToBeVisionModel.Model) {
        do {
            var vision = toBeVision
            if let visionImage = image {
                vision.imageURL = try worker.saveImage(visionImage)
                vision.lastUpdated = Date()
            }
            worker.updateMyToBeVision(vision)
            presenter.updateToBeVision()
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

    var navigationItem: NavigationItem {
        return worker.navItem
    }

    var myToBeVision: MyToBeVisionModel.Model? {
        return worker.myToBeVision()
    }

    func isReady() -> Bool {
        return worker.isReady()
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

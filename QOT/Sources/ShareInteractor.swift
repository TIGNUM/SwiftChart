//
//  ShareInteractor.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class ShareInteractor: ShareInteractorInterface {

    let worker: ShareWorker
    let router: ShareRouterInterface
    let presenter: SharePresenterInterface

    init(worker: ShareWorker, router: ShareRouterInterface, presenter: SharePresenterInterface) {
        self.worker = worker
        self.router = router
        self.presenter = presenter
    }

    func viewDidLoad() {
        worker.preUpSyncData()

        presenter.setup(name: worker.name + " " + worker.surname,
                        relationship: worker.relationship,
                        email: worker.email,
                        imageURL: worker.imageURL,
                        initials: worker.initials)
    }

    func didTapClose() {
        router.dismiss()
    }

    func didTapShareToBeVision() {
        var hasMyToBeVision = false
        let myToBeVision = worker.services.userService.myToBeVision()
        hasMyToBeVision = myToBeVision?.headline != nil

        if hasMyToBeVision == false {
            router.showAlert(.noMyToBeVision)
            return
        }

        presenter.setLoading(loading: true)
        worker.sharingType = .toBeVision
        worker.shareToBeVisionEmailContent { [weak self] (result) in
            self?.presenter.setLoading(loading: false)
            self?.handleResult(result)
        }
    }

    func didTapShareWeeklyChoices() {
        let weeklyChoices = worker.services.userService.userChoices()
        let hasWeeklyChoice = weeklyChoices.count > 0

        if hasWeeklyChoice == false {
            router.showAlert(.noWeeklyChoice)
            return
        }

        presenter.setLoading(loading: true)
        worker.sharingType = .weeklyChoices
        worker.shareWeeklyChoicesEmailContent { [weak self] (result) in
            self?.presenter.setLoading(loading: false)
            self?.handleResult(result)
        }
    }
}

// MARK: - Private

private extension ShareInteractor {

    func handleResult(_ result: ShareWorker.Result) {
        switch result {
        case .success(let content):
            router.showMailComposer(email: content.email, subject: content.subject, messageBody: content.body)
        case .failure(let error):
            if error is SyncError || error is NetworkError {
                router.showAlert(.noNetworkConnection)
            } else {
                switch worker.sharingType {
                case .toBeVision?:
                    router.showAlert(.canNotSendEmailToBeVision)
                case .weeklyChoices?:
                    router.showAlert(.canNotSendEmailWeeklyChoices)
                default:
                    router.showAlert(.unknown)
                }
            }
        }
    }
}

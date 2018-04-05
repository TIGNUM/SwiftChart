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
        presenter.setup(name: worker.name, imageURL: worker.imageURL, initials: worker.initials)
    }

    func didTapClose() {
        router.dismiss()
    }

    func didTapShareToBeVision() {
        presenter.setLoading(loading: true)
        worker.sharingType = .toBeVision
        worker.shareToBeVisionEmailContent { [weak self] (result) in
            self?.presenter.setLoading(loading: false)
            self?.handleResult(result)
        }
    }

    func didTapShareWeeklyChoices() {
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
            self.router.showMailComposer(email: content.email, subject: content.subject, messageBody: content.body)
        case .failure:
            if worker.sharingType == .toBeVision {
                self.router.showAlert(.canNotSendEmailToBeVision)
            } else {
                self.router.showAlert(.canNotSendEmailWeeklyChoices)
            }
        }
    }
}

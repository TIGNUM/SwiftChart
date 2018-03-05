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
        presenter.setup(name: worker.partnerName)
    }

    func didTapClose() {
        router.dismiss()
    }

    func didTapShareToBeVision() {
        do {
            let content = try worker.shareToBeVisionEmailContent()
            router.showMailComposer(email: content.email, subject: content.subject, messageBody: content.body)
        } catch {
            router.showAlert(.canNotSendMail)
        }
    }

    func didTapShareWeeklyChoices() {
        do {
            let content = try worker.shareWeeklyChoicesEmailContent()
            router.showMailComposer(email: content.email, subject: content.subject, messageBody: content.body)
        } catch {
            router.showAlert(.canNotSendMail)
        }
    }
}

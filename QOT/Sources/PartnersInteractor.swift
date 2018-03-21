//
//  ShareInteractor.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnersInteractor: PartnersInteractorInterface {

    let worker: PartnersWorker
    let router: PartnersRouterInterface
    let presenter: PartnersPresenterInterface

    init(worker: PartnersWorker, router: PartnersRouterInterface, presenter: PartnersPresenterInterface) {
        self.worker = worker
        self.router = router
        self.presenter = presenter
    }

    func viewDidLoad() {
        presenter.setup(partners: worker.partners())
    }

    func updateImage(_ image: UIImage, partner: Partners.Partner) {
        do {
            partner.imageURL = try worker.saveImage(image)
            presenter.reload(partner: partner)
        } catch {
            let alert = AlertType.custom(title: R.string.localized.meSectorMyWhyPartnersPhotoErrorTitle(),
                                         message: R.string.localized.meSectorMyWhyPartnersPhotoErrorMessage())
            router.showAlert(alert)
        }
    }

    func didTapShare(partner: Partners.Partner, in partners: [Partners.Partner]) {
        worker.savePartners(partners)
        router.showShare(partner: partner)
    }

    func didTapSendInvite(partner: Partners.Partner) {
        router.showPartnerInviteNotification(partner: partner) {
            self.worker.invitePartner(partner: partner) { (result) in
                self.handleResult(result)
            }
        }
    }

    func didTapClose(partners: [Partners.Partner]) {
        let incompletePartners = partners.filter({ $0.isValid == false && $0.isEmpty == false })
        if incompletePartners.isEmpty {
            worker.savePartners(partners)
            router.dismiss()
        } else {
            let title = R.string.localized.partnersAlertImcompleteTitle()
            let message = R.string.localized.partnersAlertImcompleteMessage()
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelTitle = R.string.localized.alertButtonTitleCancel()
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            let continueTitle = R.string.localized.alertButtonTitleContinue()
            let continueAction = UIAlertAction(title: continueTitle, style: .destructive) { [weak self] (action) in
                self?.worker.savePartners(partners)
                self?.router.dismiss()
            }
            alert.addAction(cancelAction)
            alert.addAction(continueAction)
            router.showAlert(alert)
        }
    }
}

// MARK: - Private

private extension PartnersInteractor {

    func handleResult(_ result: PartnersWorker.Result) {
        switch result {
        case .success(let content):
            self.router.showMailComposer(email: content.email, subject: content.subject, messageBody: content.body)
        case .failure:
            self.router.showAlert(.canNotSendMail)
        }
    }
}

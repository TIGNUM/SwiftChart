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

    func didTapShare(partner: Partners.Partner) {
        router.showShare(partner: partner)
    }

    func didTapClose(partners: [Partners.Partner]) {
        worker.savePartners(partners)
        router.dismiss()
    }
}

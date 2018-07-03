//
//  PartnerEditInteractor.swift
//  QOT
//
//  Created by karmic on 12.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnerEditInteractor {

    // MARK: - Properties

    private let worker: PartnerEditWorker
    private let presenter: PartnerEditPresenterInterface
    private let router: PartnerEditRouterInterface
    private let isNewPartner: Bool

    // MARK: - Init

    init(worker: PartnerEditWorker,
        presenter: PartnerEditPresenterInterface,
        router: PartnerEditRouterInterface,
        isNewPartner: Bool = false) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.isNewPartner = isNewPartner
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView(partner: worker.partnerToEdit, isNewPartner: isNewPartner)
    }
}

// MARK: - PartnerEditInteractorInterface

extension PartnerEditInteractor: PartnerEditInteractorInterface {

    func update(partner: Partners.Partner?) {
        guard let partner = partner else { return }
        presenter.reload(partner: partner)
    }

    func showImagePicker() {
        router.showImagePicker()
    }

    func didTapSave(partner: Partners.Partner?, image: UIImage?) {
        if let partner = partner, partner.isValid == true {
            router.showProgressHUD("")
            if let image = image {
                do {
                    let imageURL = try worker.saveImage(image)
                    partner.imageURL = imageURL
                } catch {
                    log("Error while saving partner profile image: \(error)")
                }
            }
            worker.savePartner(partner, completion: { (error) in
                self.router.hideProgressHUD()
                self.router.dismiss(partner)
            })
        } else {
            router.showAlert(.partnerIncomplete)
        }
    }

    func didTapDelete(partner: Partners.Partner?) {
        if let partner = partner, partner.isValid == true {
            router.showProgressHUD("")
            worker.deletePartner(partner, completion: { (error) in
                if error != nil {
                    self.router.showAlert(.canNotDeletePartner)
                }
                self.router.hideProgressHUD()
                self.router.dismiss(partner)
            })
        } else {
            router.showAlert(.canNotDeletePartner)
        }
    }

    func didTapCancel() {
        router.dismiss(worker.partnerToEdit)
    }
}

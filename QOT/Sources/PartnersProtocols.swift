//
//  ShareProtocols.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

protocol PartnersViewControllerInterface: class {
    func setup(partners: [Partners.Partner])
    func reload(partner: Partners.Partner)
}

protocol PartnersPresenterInterface {
    func setup(partners: [Partners.Partner])
    func reload(partner: Partners.Partner)
}

protocol PartnersInteractorInterface: Interactor {
    func didTapClose(partners: [Partners.Partner])
    func didTapShare(partner: Partners.Partner, in partners: [Partners.Partner])
    func updateImage(_ image: UIImage, partner: Partners.Partner)
}

protocol PartnersRouterInterface {
    func dismiss()
    func showAlert(_ alert: AlertType)
    func showAlert(_ alert: UIAlertController)
    func showShare(partner: Partners.Partner)
    func showMailComposer(email: String, subject: String, messageBody: String)
}

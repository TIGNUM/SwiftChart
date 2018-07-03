//
//  PartnersOverviewInterface.swift
//  QOT
//
//  Created by karmic on 15.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

protocol PartnersOverviewViewControllerInterface: class {
    func setup(partners: [Partners.Partner])
    func reload(partner: Partners.Partner)
}

protocol PartnersOverviewPresenterInterface {
    func setup(partners: [Partners.Partner])
    func reload(partner: Partners.Partner)
}

protocol PartnersOverviewInteractorInterface: Interactor {
    func didTapClose()
    func didTapShare(partner: Partners.Partner)
    func addPartner(partner: Partners.Partner)
    func editPartner(partner: Partners.Partner)
    func reload()
    var landingPage: PartnersLandingPage? { get }
}

protocol PartnersOverviewRouterInterface {
    func dismiss()
    func showShare(partner: Partners.Partner)
    func showMailComposer(email: String, subject: String, messageBody: String)
    func showAddPartner(partner: Partners.Partner)
    func showEditPartner(partner: Partners.Partner)
    func showAlert(_ alert: AlertType)
}

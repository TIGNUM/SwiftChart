//
//  PartnersOverviewInterface.swift
//  QOT
//
//  Created by karmic on 15.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

protocol PartnersOverviewViewControllerInterface: class {
    func setup(partners: [Partner])
    func reload(partner: Partner)
}

protocol PartnersOverviewPresenterInterface {
    func setup(partners: [Partner])
    func reload(partner: Partner)
}

protocol PartnersOverviewInteractorInterface: Interactor {
    func didTapClose()
    func didTapShare(partner: Partner)
    func addPartner(partner: Partner)
    func editPartner(partner: Partner)
    func reload()
}

protocol PartnersOverviewRouterInterface {
    func dismiss()
    func showShare(partner: Partner)
    func showMailComposer(email: String, subject: String, messageBody: String)
    func showAddPartner(partner: Partner)
    func showEditPartner(partner: Partner)
    func showAlert(_ alert: AlertType)
}

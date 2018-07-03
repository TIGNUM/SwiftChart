//
//  ShareProtocols.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

protocol ShareViewControllerInterface: class {
    func setup()
    func setPartnerProfileImage()
    func setLoading(loading: Bool)
}

protocol SharePresenterInterface {
    func setup()
    func setLoading(loading: Bool)
}

protocol ShareInteractorInterface: Interactor {
    var partner: Partners.Partner { get }
    func didTapClose()
    func didTapShareToBeVision()
    func didTapShareWeeklyChoices()
    func didTapEditPartner(partner: Partners.Partner?)
}

protocol ShareRouterInterface {
    func dismiss()
    func showAlert(_ alert: AlertType)
    func showMailComposer(email: String, subject: String, messageBody: String)
    func showEditPartner(partner: Partners.Partner?)
}

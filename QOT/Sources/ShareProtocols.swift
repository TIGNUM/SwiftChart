//
//  ShareProtocols.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

protocol ShareViewControllerInterface: class {
    func setup(name: String, relationship: String, email: String)
    func setPartnerProfileImage(_ imageURL: URL?, initials: String)
    func setLoading(loading: Bool)
}

protocol SharePresenterInterface {
    func setup(name: String, relationship: String, email: String, imageURL: URL?, initials: String)
    func setLoading(loading: Bool)
}

protocol ShareInteractorInterface: Interactor {
    func didTapClose()
    func didTapShareToBeVision()
    func didTapShareWeeklyChoices()
}

protocol ShareRouterInterface {
    func dismiss()
    func showAlert(_ alert: AlertType)
    func showMailComposer(email: String, subject: String, messageBody: String)
}

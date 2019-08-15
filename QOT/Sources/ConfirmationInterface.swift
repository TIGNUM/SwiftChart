//
//  ConfirmationInterface.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 09.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol ConfirmationViewControllerInterface: class {
    func setupView()
    func load(_ confirmationModel: Confirmation)
}

protocol ConfirmationPresenterInterface {
    func setupView()
    func show(_ confirmationModel: Confirmation)
}

protocol ConfirmationInteractorInterface: Interactor {
    func didTapLeave()
    func didTapDismiss()
}

protocol ConfirmationRouterInterface {
    func leave()
    func dismiss()
}

//
//  ConfirmationInterface.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 09.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol ConfirmationViewControllerInterface: class {
    func load(_ confirmationModel: ConfirmationModel)
}

protocol ConfirmationPresenterInterface {
    func show(_ confirmationModel: ConfirmationModel)
}

protocol ConfirmationInteractorInterface: Interactor {
    func didTap(_ buttonType: ConfirmationButtonType)
}

protocol ConfirmationRouterInterface {
    func dismiss()
}

protocol ConfirmationWorkerInterface {
    func model() -> ConfirmationModel
}

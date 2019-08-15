//
//  ShifterResultInterface.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol ShifterResultViewControllerInterface: class {
    func load(_ model: ShifterResult)
    func setupView()
}

protocol ShifterResultPresenterInterface {
    func load(_ model: ShifterResult)
    func setupView()
}

protocol ShifterResultInteractorInterface: Interactor {
    func didTapClose()
    func didTapSave()
    func openConfirmationView()
}

protocol ShifterResultRouterInterface {
    func dismiss()
    func openConfirmationView(_ kind: Confirmation.Kind)
}

//
//  ShifterResultRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ShifterResultRouter {

    // MARK: - Properties
    private let viewController: ShifterResultViewController

    // MARK: - Init
    init(viewController: ShifterResultViewController) {
        self.viewController = viewController
    }
}

// MARK: - ShifterResultRouterInterface
extension ShifterResultRouter: ShifterResultRouterInterface {
    func dismiss() {
        let configurator = ConfirmationConfigurator.make(for: .mindsetShifter)
        let confirmationVC = ConfirmationViewController(configure: configurator)
        confirmationVC.delegate = self
        confirmationVC.modalPresentationStyle = .overCurrentContext
        viewController.present(confirmationVC, animated: true, completion: nil)
    }
}

extension ShifterResultRouter: ConfirmationViewControllerDelegate {
    func didTapLeave() {
        viewController.dismiss(animated: true, completion: nil)
    }

    func didTapStay() {
    }

    func openConfirmationView(_ kind: Confirmation.Kind) {
        let configurator = ConfirmationConfigurator.make(for: kind)
        let controller = ConfirmationViewController(configure: configurator)
        controller.delegate = viewController
        viewController.present(controller, animated: true)
    }
}

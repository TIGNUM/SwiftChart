//
//  MindsetShifterChecklistRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MindsetShifterChecklistRouter {

    // MARK: - Properties

    private let viewController: MindsetShifterChecklistViewController

    // MARK: - Init

    init(viewController: MindsetShifterChecklistViewController) {
        self.viewController = viewController
    }
}

// MARK: - MindsetShifterChecklistRouterInterface

extension MindsetShifterChecklistRouter: MindsetShifterChecklistRouterInterface {

    func dismiss() {
        let configurator = ConfirmationConfigurator.make()
        let confirmationVC = ConfirmationViewController(configure: configurator)
        confirmationVC.modalPresentationStyle = .overCurrentContext
        viewController.present(confirmationVC, animated: true, completion: nil)
    }
}

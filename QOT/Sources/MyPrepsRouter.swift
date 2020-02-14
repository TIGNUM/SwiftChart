//
//  MyPrepsRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyPrepsRouter {

    // MARK: - Properties
    private weak var viewController: MyPrepsViewController?
    weak var delegate: CoachCollectionViewControllerDelegate?

    // MARK: - Init
    init(viewController: MyPrepsViewController) {
        self.viewController = viewController
    }
}

// MARK: - MyPrepsRouterInterface
extension MyPrepsRouter: MyPrepsRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true)
    }

    func createEventPlan() {
        let configurator = DTPrepareConfigurator.make()
        let controller = DTPrepareViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }

    func createRecoveryPlan() {
        let configurator = DTRecoveryConfigurator.make()
        let controller = DTRecoveryViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }

    func createMindsetShifter() {
        let configurator = DTMindsetConfigurator.make()
        let controller = DTMindsetViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }
}

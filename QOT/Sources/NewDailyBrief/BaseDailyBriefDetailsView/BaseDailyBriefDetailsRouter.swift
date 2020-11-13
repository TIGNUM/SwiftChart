//
//  BaseDailyBriefDetailsRouter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 09/11/2020.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class BaseDailyBriefDetailsRouter {

    // MARK: - Properties
    private weak var viewController: BaseDailyBriefDetailsViewController?

    // MARK: - Init
    init(viewController: BaseDailyBriefDetailsViewController?) {
        self.viewController = viewController
    }

    func popBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

// MARK: - BaseDailyBriefDetailsRouterInterface
extension BaseDailyBriefDetailsRouter: BaseDailyBriefDetailsRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}

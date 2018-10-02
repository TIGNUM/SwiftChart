//
//  SupportFAQPresenter.swift
//  QOT
//
//  Created by karmic on 01.10.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SupportFAQPresenter {

    // MARK: - Properties

    private weak var viewController: SupportFAQViewControllerInterface?

    // MARK: - Init

    init(viewController: SupportFAQViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SupportFAQInterface

extension SupportFAQPresenter: SupportFAQPresenterInterface {

    func setupView() {
        viewController?.setupView()
    }
}

//
//  ShifterResultPresenter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ShifterResultPresenter {

    // MARK: - Properties
    private weak var viewController: ShifterResultViewControllerInterface?

    // MARK: - Init
    init(viewController: ShifterResultViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - ShifterResultPresenterInterface
extension ShifterResultPresenter: ShifterResultPresenterInterface {
    func load(_ model: ShifterResult) {
        viewController?.load(model)
    }

    func setupView() {
        viewController?.setupView()
    }
}

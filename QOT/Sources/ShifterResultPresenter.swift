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
    func load(_ model: MindsetResult) {
        viewController?.load(model)
    }

    func setupView() {
        viewController?.setupView()
    }

    func presentAlert(title: String, message: String, cancelTitle: String, leaveTitle: String) {
        viewController?.showAlert(title: title, message: message, cancelTitle: cancelTitle, leaveTitle: leaveTitle)
    }
}

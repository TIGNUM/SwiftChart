//
//  PrepareResultsPresenter.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class PrepareResultsPresenter {

    // MARK: - Properties

    private weak var viewController: PrepareResultsViewControllerInterface?

    // MARK: - Init

    init(viewController: PrepareResultsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - PrepareResultsInterface

extension PrepareResultsPresenter: PrepareResultsPresenterInterface {
    func reloadView() {
        viewController?.reloadView()
    }

    func registerTableViewCell(_ type: QDMUserPreparation.Level) {
        viewController?.registerTableViewCell(type)
    }

    func setupView() {
        viewController?.setupView()
    }

    func presentAlert(title: String, message: String, cancelTitle: String, leaveTitle: String) {
        viewController?.showAlert(title: title, message: message, cancelTitle: cancelTitle, leaveTitle: leaveTitle)
    }
}

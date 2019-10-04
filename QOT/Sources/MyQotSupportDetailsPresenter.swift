//
//  MyQotSupportDetailsPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSupportDetailsPresenter {

    // MARK: - Properties

    private weak var viewController: MyQotSupportDetailsViewControllerInterface?

    // MARK: - Init

    init(viewController: MyQotSupportDetailsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SupportFAQInterface

extension MyQotSupportDetailsPresenter: MyQotSupportDetailsPresenterInterface {

    func setupView() {
        viewController?.setupView()
    }
}

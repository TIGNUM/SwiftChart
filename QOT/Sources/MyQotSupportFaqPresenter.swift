//
//  MyQotSupportFaqPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSupportFaqPresenter {

    // MARK: - Properties

    private weak var viewController: MyQotSupportFaqViewControllerInterface?

    // MARK: - Init

    init(viewController: MyQotSupportFaqViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SupportFAQInterface

extension MyQotSupportFaqPresenter: MyQotSupportFaqPresenterInterface {

    func setupView(with title: String) {
        viewController?.setupView(with: title)
    }
}

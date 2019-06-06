//
//  MyQotAboutUsPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAboutUsPresenter {
    // MARK: - Properties

    private weak var viewController: MyQotAboutUsViewControllerInterface?

    // MARK: - Init

    init(viewController: MyQotAboutUsViewControllerInterface) {
        self.viewController = viewController
    }
}

extension MyQotAboutUsPresenter: MyQotAboutUsPresenterInterface {

    func setupView(with title: String) {
        viewController?.setupView(with: title)
    }
}

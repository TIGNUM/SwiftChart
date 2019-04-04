//
//  MyQotPresenter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotPresenter {

    // MARK: - Properties

    private weak var viewController: MyQotViewControllerInterface?

    // MARK: - Init

    init(viewController: MyQotViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MyQotInterface

extension MyQotPresenter: MyQotPresenterInterface {

    func setupView() {
        viewController?.setupView()
    }
}

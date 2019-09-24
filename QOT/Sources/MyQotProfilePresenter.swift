//
//  MyQotPresenter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotProfilePresenter {

    // MARK: - Properties

    private weak var viewController: MyQotProfileViewControllerInterface?

    // MARK: - Init

    init(viewController: MyQotProfileViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MyQotInterface

extension MyQotProfilePresenter: MyQotProfilePresenterInterface {
    func updateView() {
        viewController?.updateView()
    }
}

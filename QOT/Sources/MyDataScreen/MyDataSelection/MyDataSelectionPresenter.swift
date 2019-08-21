//
//  MyDataSelectionPresenter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyDataSelectionPresenter {

    // MARK: - Properties
    private weak var viewController: MyDataSelectionViewControllerInterface?

    // MARK: - Init
    init(viewController: MyDataSelectionViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - MyDataSelectionInterface
extension MyDataSelectionPresenter: MyDataSelectionPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}

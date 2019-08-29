//
//  MySprintsListPresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MySprintsListPresenter {

    // MARK: - Properties

    private weak var viewController: MySprintsListViewControllerInterface?

    // MARK: - Init

    init(viewController: MySprintsListViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MySprintsListInterface

extension MySprintsListPresenter: MySprintsListPresenterInterface {
    func present() {
        viewController?.update()
    }

    func presentData() {
        viewController?.reloadData()
    }

    func presentAlert(title: String, message: String, buttons: [UIBarButtonItem]) {
        viewController?.presentAlert(title: title, message: message, buttons: buttons)
    }
}

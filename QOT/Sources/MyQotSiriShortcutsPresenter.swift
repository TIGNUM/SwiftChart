//
//  MyQotSiriShortcutsPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSiriShortcutsPresenter {

    // MARK: - Properties

    private weak var viewController: MyQotSiriShortcutsViewControllerInterface?

    // MARK: - Init

    init(viewController: MyQotSiriShortcutsViewControllerInterface) {
        self.viewController = viewController
    }
}

extension MyQotSiriShortcutsPresenter: MyQotSiriShortcutsPresenterInterface {
    func setupView(with title: String) {
        viewController?.setupView(with: title)
    }
}

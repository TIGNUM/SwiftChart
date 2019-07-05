//
//  MyQotMainPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotMainPresenter {

    // MARK: - Properties

    private weak var viewController: MyQotMainViewControllerInterface?

    // MARK: - Init

    init(viewController: MyQotMainViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - KnowingInterface

extension MyQotMainPresenter: MyQotMainPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func present(for myQotSection: MyQotViewModel) {
        viewController?.setup(for: myQotSection)
    }
}

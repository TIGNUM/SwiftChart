//
//  LevelTwoPresenter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class LevelTwoPresenter {

    // MARK: - Properties

    private weak var viewController: LevelTwoViewControllerInterface?

    // MARK: - Init

    init(viewController: LevelTwoViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - LevelTwoInterface

extension LevelTwoPresenter: LevelTwoPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}

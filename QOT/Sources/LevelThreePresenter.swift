//
//  LevelThreePresenter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class LevelThreePresenter {

    // MARK: - Properties

    private weak var viewController: LevelThreeViewControllerInterface?

    // MARK: - Init

    init(viewController: LevelThreeViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - LevelThreeInterface

extension LevelThreePresenter: LevelThreePresenterInterface {

}

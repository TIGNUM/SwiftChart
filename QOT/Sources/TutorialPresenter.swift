//
//  TutorialPresenter.swift
//  QOT
//
//  Created by karmic on 16.11.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class TutorialPresenter {

    // MARK: - Properties

    private weak var viewController: TutorialViewControllerInterface?

    // MARK: - Init

    init(viewController: TutorialViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - TutorialInterface

extension TutorialPresenter: TutorialPresenterInterface {

    func setup() {
        viewController?.setup()
    }
}

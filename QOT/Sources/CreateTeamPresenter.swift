//
//  CreateTeamPresenter.swift
//  QOT
//
//  Created by karmic on 19.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class CreateTeamPresenter {

    // MARK: - Properties
    private weak var viewController: CreateTeamViewControllerInterface?

    // MARK: - Init
    init(viewController: CreateTeamViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - CreateTeamInterface
extension CreateTeamPresenter: CreateTeamPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}

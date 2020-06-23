//
//  CreateTeamPresenter.swift
//  QOT
//
//  Created by karmic on 19.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

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

        /// TODO Please Change me before PR..
        viewController?.setupLabels(header: "Please Create a team",
                                    description: "Please chose a team name",
                                    buttonTitle: "Please create")

//        viewController?.setupLabels(header: AppTextService.get(.my_x_team_create_header),
//                                    description: AppTextService.get(.my_x_team_create_description),
//                                    buttonTitle: AppTextService.get(.my_x_team_create_cta))
    }

    func presentInviteView() {
        viewController?.presentInviteView()
    }
}

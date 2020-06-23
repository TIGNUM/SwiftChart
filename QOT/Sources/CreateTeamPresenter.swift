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
        viewController?.setupLabels(header: AppTextService.get(.my_x_team_create_header),
                                    description: AppTextService.get(.my_x_team_create_description),
                                    buttonTitle: AppTextService.get(.my_x_team_create_cta))
    }

    func handleResponse(_ team: QDMTeam?, error: Error?) {
        if let error = error {
            log("Error while create team: \(error.localizedDescription)", level: .error)
            viewController?.showErrorAlert(error)
        } else if team == nil {
            log("Team could not be created. Did not get a valid team as response.", level: .error)
            let error = NSError(domain: TeamServiceErrorDomain,
                                code: TeamServiceErrorCode.CannotFindTeam.rawValue,
                                userInfo: nil)
            viewController?.showErrorAlert(error)
        } else {
            viewController?.presentInviteView()
        }
    }
}

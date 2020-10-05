//
//  TeamToBeVisionOptionsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamToBeVisionOptionsInteractor: WorkerTeam {

    // MARK: - Properties
    private lazy var worker = TeamToBeVisionOptionsWorker()
    private let presenter: TeamToBeVisionOptionsPresenterInterface!
    private var type = TeamToBeVisionOptionsModel.Types.voting
    private var model = TeamToBeVisionOptionsModel()
    private var poll: QDMTeamToBeVisionPoll?

    // MARK: - Init
    init(presenter: TeamToBeVisionOptionsPresenterInterface,
         type: TeamToBeVisionOptionsModel.Types,
         poll: QDMTeamToBeVisionPoll?) {
        self.presenter = presenter
        self.type = type
        self.poll = poll
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView(type: type,
                            headerSubtitle: getTeamTBVPollRemainingDays(poll?.remainingDays ?? 0))
    }
}

// MARK: - TeamToBeVisionOptionsInteractorInterface
extension TeamToBeVisionOptionsInteractor: TeamToBeVisionOptionsInteractorInterface {
    var getType: TeamToBeVisionOptionsModel.Types {
        return type
    }

    var daysLeft: Int {
        return poll?.remainingDays ?? 0
    }

    var alertCancelTitle: String {
        return AppTextService.get(.my_x_team_tbv_options_alert_leftButton)
    }

    var alertEndTitle: String {
        return AppTextService.get(.my_x_team_tbv_options_alert_rightButton)
    }

    var userDidVote: Bool {
        return poll?.userDidVote == true
    }
}

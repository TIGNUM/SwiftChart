//
//  DTTeamTBVViewController.swift
//  QOT
//
//  Created by karmic on 04.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTTeamTBVViewController: DTViewController {

    var tbvTeamInteractor: DTTeamTBVInteractorInterface?

    // MARK: - Init
    init(configure: Configurator<DTTeamTBVViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didTapClose() {
        router?.dismissChatBotFlow()
    }

    override func didTapNext() {
        let answers = viewModel?.answers.filter { $0.selected } ?? []
        if let question = viewModel?.question {
            tbvTeamInteractor?.voteTeamToBeVisionPoll(question: question,
                                                      votes: answers) { (poll) in

                let buttonTitle = AppTextService.get(.onboarding_log_in_alert_device_small_screen_button_got_it)
                let buttonGotIt = QOTAlertAction(title: buttonTitle) { [weak self] (_) in
                    self?.router?.dismiss()
                }
                let title = AppTextService.get(.alert_title_team_tbv_poll_submitted)
                var message = AppTextService.get(.alert_message_team_tbv_poll_submitted)
                let remainingDays = Date().days(to: poll?.endDate ?? Date())
                message = message.replacingOccurrences(of: "%d", with: String(remainingDays))

                QOTAlert.show(title: title, message: message, bottomItems: [buttonGotIt])
            }
        }
    }
}

// MARK: - DTTeamTBVViewControllerInterface
extension DTTeamTBVViewController: DTTeamTBVViewControllerInterface {}

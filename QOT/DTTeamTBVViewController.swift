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

    var tbvTeamInteractor: DTTeamTBVInteractorInterface!

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
        vote()
    }
}

private extension DTTeamTBVViewController {
    func vote() {
        let votes = viewModel?.answers.filter { $0.selected } ?? []
        if let question = viewModel?.question {
            tbvTeamInteractor.voteTeamToBeVisionPoll(question: question, votes: votes) { [weak self] (poll) in
                self?.showDialog(poll)
            }
        }
    }

    func showDialog(_ poll: QDMTeamToBeVisionPoll?) {
        let buttonTitle = AppTextService.get(.onboarding_log_in_alert_device_small_screen_button_got_it)
        let title = AppTextService.get(.alert_title_team_tbv_poll_submitted)
        var message = AppTextService.get(.alert_message_team_tbv_poll_submitted)
        message = message.replacingOccurrences(of: "%d", with: String(poll?.remainingDays ?? 0))

        let buttonGotIt = QOTAlertAction(title: buttonTitle) { [weak self] (_) in
            self?.tbvTeamInteractor.teamToBeVisionExist { (teamToBeVisionExist) in
                if teamToBeVisionExist {
                    self?.didTapClose()
                } else {
                    AppDelegate.current.launchHandler.showFirstLevelScreen(page: .myX)
                }
            }
        }

        QOTAlert.show(title: title, message: message, bottomItems: [buttonGotIt])
    }
}

// MARK: - DTTeamTBVViewControllerInterface
extension DTTeamTBVViewController: DTTeamTBVViewControllerInterface {}

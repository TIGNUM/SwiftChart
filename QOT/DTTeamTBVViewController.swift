//
//  DTTeamTBVViewController.swift
//  QOT
//
//  Created by karmic on 04.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

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
                print(poll)
            }
        }

//        tbvTeamInteractor?.generateTBV(answers: answers) { [weak self] (teamTBV) in
//            print(self?.viewModel?.question.key)
//            print(teamTBV)
//            self?.router?.dismiss()
//        }
    }
}

// MARK: - DTTeamTBVViewControllerInterface
extension DTTeamTBVViewController: DTTeamTBVViewControllerInterface {}

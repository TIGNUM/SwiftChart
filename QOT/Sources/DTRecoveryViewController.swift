//
//  DTRecoveryViewController.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTRecoveryViewController: DTViewController {

    // MARK: - Properties
    var recoveryInteractor: DTRecoveryInteractorInterface?
    var recoveryRouter: DTRecoveryRouterInterface?

    // MARK: - Init
    init(configure: Configurator<DTRecoveryViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Answer Handling
    override func didTapNext() {
        switch viewModel?.question.key {
        case Recovery.QuestionKey.Intro?:
            setNextQuestionForFatigueSymptoms()
        case Recovery.QuestionKey.GeneratePlan?:
            presentRecoveryResults()
        case Recovery.QuestionKey.Last?:
            router?.dismiss()
        default:
            loadNextQuestion()
        }
    }

    override func didSelectAnswer(_ answer: DTViewModel.Answer) {
        super.didSelectAnswer(answer)
    }

    override func didDeSelectAnswer(_ answer: DTViewModel.Answer) {
        super.didDeSelectAnswer(answer)
    }

    // MARK: - Question Handling
    override func getAnswerFilter(selectedAnswers: [DTViewModel.Answer], questionKey: String?) -> String? {
        if questionKey == Recovery.QuestionKey.Intro {
            return Recovery.getFatigueSymptom(selectedAnswers).answerFilter
        }
        return nil
    }
}

// MARK: - Private
private extension DTRecoveryViewController {
    func setNextQuestionForFatigueSymptoms() {
        if case .general = Recovery.getFatigueSymptom(viewModel?.selectedAnswers ?? []) {
            recoveryInteractor?.nextQuestionKey = Recovery.QuestionKey.SymptomGeneral
            loadNextQuestion()
        } else {
            loadNextQuestion()
        }
    }

    func presentRecoveryResults() {
        recoveryInteractor?.nextQuestionKey = Recovery.QuestionKey.Last
        setAnswerNeedsSelection()
        recoveryInteractor?.getRecovery3D { [weak self] (recovery) in
            self?.recoveryRouter?.presentRecoveryResults(recovery) {
                self?.loadNextQuestion()
            }
        }
    }
}

// MARK: - DTRecoveryViewControllerInterface
extension DTRecoveryViewController: DTRecoveryViewControllerInterface {}

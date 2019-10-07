//
//  DTSolveViewController.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTSolveViewController: DTViewController {

    // MARK: - Properties
    var solveRouter: DTSolveRouterInterface?
    var solveInteractor: DTSolveInteractorInterface?
    weak var shortTBVDelegate: DTShortTBVDelegate?

    // MARK: - Init
    init(configure: Configurator<DTSolveViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - DTQuestionnaireViewControllerDelegate
    override func didTapNext() {
        switch viewModel?.question.key {
        case Solve.QuestionKey.BackFromShortTBV:
            if let answer = viewModel?.answers.first {
                solveRouter?.presentSolveResults(selectedAnswer: answer)
            }
        default:
            super.didTapNext()
        }
    }

    override func didSelectAnswer(_ answer: DTViewModel.Answer) {
        setSelectedAnswer(answer)
        if viewModel?.question.answerType == .singleSelection {
            if answer.targetId(.content) != nil {
                solveRouter?.presentSolveResults(selectedAnswer: answer)
            } else if answer.targetId(.question) != nil {
                handleQuestionSelection(answer)
            } else if answer.keys.contains(Solve.AnswerKey.OpenVisionPage) {
                solveRouter?.dismissFlowAndGoToMyTBV()
            }
        }
    }
}

// MARK: - Actions
private extension DTSolveViewController {
    func handleQuestionSelection(_ answer: DTViewModel.Answer) {
        if answer.keys.contains(Solve.AnswerKey.OpenTBV) {
            handleTBVCase(answer)
        } else {
            loadNextQuestion()
        }
    }

    func handleTBVCase(_ answer: DTViewModel.Answer) {
        interactor?.getUsersTBV { [weak self] (tbv, initiated) in
            if initiated && tbv?.text != nil {
                let targetAnswer = DTViewModel.Answer(answer: answer,
                                                      newTargetId: Solve.QuestionTargetId.ReviewTBV)
                self?.setAnswerNeedsSelection(targetAnswer)
                self?.loadNextQuestion()
            } else {
                self?.solveRouter?.loadShortTBVGenerator(introKey: ShortTBV.QuestionKey.Work,
                                                         delegate: self?.shortTBVDelegate) { [weak self] in
                                                            let targetId = Solve.QuestionTargetId.PostCreationShortTBV
                                                            let targetAnswer = DTViewModel.Answer(answer: answer,
                                                                                                  newTargetId: targetId)
                                                            self?.setAnswerNeedsSelection(targetAnswer)
                                                            self?.loadNextQuestion()
                }
            }
        }
    }
}

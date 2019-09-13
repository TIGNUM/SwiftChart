//
//  DTSolveViewController.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTSolveViewController: DTViewController {

    // MARK: - Properties
    var solveRouter: DTSolveRouterInterface?
    var solveInteractor: DTSolveInteractorInterface?

    // MARK: - Init
    init(configure: Configurator<DTSolveViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - DTQuestionnaireViewControllerDelegate
    override func didTapBinarySelection(_ answer: DTViewModel.Answer) {
        super.didTapBinarySelection(answer)
    }

    override func didSelectAnswer(_ answer: DTViewModel.Answer) {
        viewModel?.setSelectedAnswer(answer)
        if viewModel?.question.answerType == .singleSelection {
            if answer.targetId(.content) != nil {
                solveRouter?.presentSolveResults(selectedAnswer: answer)
            } else if answer.targetId(.content) != nil {
                handleQuestionSelection(answer)
            }
        }
    }
}

// MARK: - Actions
private extension DTSolveViewController {
    func handleQuestionSelection(_ answer: DTViewModel.Answer) {
        if viewModel?.question.key == Solve.QuestionKey.OpenTBV {
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
                                                         delegate: self?.solveInteractor) { [weak self] in
                                                            let targetAnswer = DTViewModel.Answer(answer: answer,
                                                                                                  newTargetId: Solve.QuestionTargetId.PostCreationShortTBV)
                                                            self?.setAnswerNeedsSelection(targetAnswer)
                                                            self?.loadNextQuestion()
                }
            }
        }
    }
}

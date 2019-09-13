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
    weak var solveRouter: DTSolveRouter?

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

    }

    override func didSelectAnswer(_ answer: DTViewModel.Answer) {
        viewModel?.setSelectedAnswer(answer)
        guard let viewModel = viewModel else { return }
        if viewModel.question.answerType == .singleSelection && answer.targetId(.question) != nil {
            loadNextQuestion()
        } else if viewModel.question.answerType == .singleSelection && answer.targetId(.content) != nil {
            solveRouter?.presentSolveResults(selectedAnswer: answer)
        }
    }
}

// MARK: - Actions
private extension DTSolveViewController {}

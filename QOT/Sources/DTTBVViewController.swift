//
//  DTTBVViewController.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTTBVViewController: DTViewController {

    var tbvInteractor: DTShortTBVInteractorInterface?

    // MARK: - Init
    init(configure: Configurator<DTTBVViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - DTViewController
    override func didTapBinarySelection(_ answer: DTViewModel.Answer) {}

    override func didTapNext() {
        if viewModel?.question.key == TBV.QuestionKey.Home {
            generateTBV()
        } else {
            setAnswerNeedsSelection()
            loadNextQuestion()
        }
    }

    override func didSelectAnswer(_ answer: DTViewModel.Answer) {
        viewModel?.setSelectedAnswer(answer)
        switch viewModel?.question.key {
        case TBV.QuestionKey.Instructions?:
            if let contentId = answer.targetId(.content) {
                router?.presentContent(contentId)
            }
            if let contentItemId = answer.targetId(.contentItem) {
                router?.playMediaItem(contentItemId)
            }
        default:
            break
        }
    }
}

// MARK: - Private
private extension DTTBVViewController {
    func generateTBV() {
        var selectedAnswers = interactor?.getSelectedAnswers() ?? []
        let answers = viewModel?.selectedAnswers ?? []
        let update = SelectedAnswer(question: viewModel?.question, answers: answers)
        selectedAnswers.append(update)
        tbvInteractor?.generateTBV(selectedAnswers) { [weak self] in
            self?.loadNextQuestion()
        }
    }
}

// MARK: - DTTBVViewControllerInterface
extension DTTBVViewController: DTTBVViewControllerInterface {}

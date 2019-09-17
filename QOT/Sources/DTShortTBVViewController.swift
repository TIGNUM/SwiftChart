//
//  DTShortTBVViewController.swift
//  QOT
//
//  Created by karmic on 10.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTShortTBVViewController: DTViewController {

    // MARK: - Properties
    var shortTBVInteractor: DTShortTBVInteractorInterface?
    weak var delegate: DTShortTBVDelegate?
    var shortTBVRouter: DTShortTBVRouterInterface?

    // MARK: - Init
    init(configure: Configurator<DTShortTBVViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - DTViewController
    override func didTapNext() {
        switch viewModel?.question.key {
        case ShortTBV.QuestionKey.Review:
            delegate?.didDismissShortTBVScene(tbv: shortTBVInteractor?.getTBV())
            if shortTBVInteractor?.shouldDismissOnContinue ?? true {
                shortTBVRouter?.dismiss()
            }
        case ShortTBV.QuestionKey.Home:
            generateTBV()
        default:
            setAnswerSelectedIfNeeded()
            loadNextQuestion()
        }
    }

    override func didTapPrevious() {
        if shortTBVInteractor?.canGoBack ?? true {
            super.didTapPrevious()
        } else {
            delegate?.didTapBack()
        }
    }
}

private extension DTShortTBVViewController {
    func setAnswerSelectedIfNeeded() {
        switch viewModel?.question.key {
        case ShortTBV.QuestionKey.IntroMindSet?,
             ShortTBV.QuestionKey.Home?:
            if var answer = viewModel?.answers.first {
                answer.setSelected(true)
                viewModel?.setSelectedAnswer(answer)
            }
        default: break
        }
    }

    func generateTBV() {
        var selectedAnswers = interactor?.getSelectedAnswers() ?? []
        let answers = viewModel?.selectedAnswers ?? []
        let update = SelectedAnswer(question: viewModel?.question, answers: answers)
        selectedAnswers.append(update)
        shortTBVInteractor?.generateTBV(selectedAnswers: selectedAnswers,
                                        questionKeyWork: ShortTBV.QuestionKey.Work,
                                        questionKeyHome: ShortTBV.QuestionKey.Home) { [weak self] _ in
            self?.loadNextQuestion()
        }
    }
}

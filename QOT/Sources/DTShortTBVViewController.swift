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
        setAnswerSelectedIfNeeded()
        if viewModel?.question.key == ShortTBV.QuestionKey.Home {
            generateTBV()
        } else {
            loadNextQuestion()
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
        shortTBVInteractor?.generateTBV { [weak self] in
            self?.loadNextQuestion()
        }
    }
}

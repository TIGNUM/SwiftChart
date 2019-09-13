//
//  DTPrepareViewController.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTPrepareViewController: DTViewController {

    // MARK: - Init
    init(configure: Configurator<DTPrepareViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Answer Handling
    override func didTapNext() {
        setAnswerNeedsSelection()
        loadNextQuestion()
    }

    override func didSelectAnswer(_ answer: DTViewModel.Answer) {
        super.didSelectAnswer(answer)
    }

    override func didDeSelectAnswer(_ answer: DTViewModel.Answer) {
        super.didDeSelectAnswer(answer)
    }
}

// MARK: - Private
private extension DTPrepareViewController {}

// MARK: - DTPrepareViewControllerInterface
extension DTPrepareViewController: DTPrepareViewControllerInterface {}

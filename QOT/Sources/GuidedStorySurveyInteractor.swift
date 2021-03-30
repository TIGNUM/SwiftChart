//
//  GuidedStorySurveyInteractor.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class GuidedStorySurveyInteractor {

    // MARK: - Properties
    private let worker: GuidedStoryWorker!
    private let presenter: GuidedStorySurveyPresenterInterface!

    // MARK: - Init
    init(presenter: GuidedStorySurveyPresenterInterface, worker: GuidedStoryWorker) {
        self.presenter = presenter
        self.worker = worker
    }

    // MARK: - Interactor
    func viewDidLoad() {
        worker.getTargetContents()
        worker.getQuestions { [weak self] in
            self?.presenter.setupView()
            self?.loadNextQuestion()
        }
    }
}

// MARK: - GuidedStorySurveyInteractorInterface
extension GuidedStorySurveyInteractor: GuidedStorySurveyInteractorInterface {
    var rowCount: Int {
        return sortedAnswers.count
    }

    func title(at index: Int) -> String? {
        return sortedAnswers.at(index: index)?.title
    }

    func subtitle(at index: Int) -> String? {
        return sortedAnswers.at(index: index)?.subtitle
    }

    func onColor(at index: Int) -> UIColor {
        return .blue
    }

    func didSelectAnswer(at index: Int) {
        worker.didSelectAnswer(at: index)
    }

    func loadNextQuestion() {
        presenter.setQuestion(worker.question())
    }
}

private extension GuidedStorySurveyInteractor {
    var currentQuestion: QDMQuestion? {
        return worker.question()
    }

    var sortedAnswers: [QDMAnswer] {
        return worker.answers()
    }
}

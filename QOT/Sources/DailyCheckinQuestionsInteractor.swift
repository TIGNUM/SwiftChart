//
//  DailyCheckinQuestionsInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 16.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DailyCheckinQuestionsInteractor {

    // MARK: - Properties

    private let worker: DailyCheckinQuestionsWorker
    private let presenter: DailyCheckinQuestionsPresenterInterface
    private let router: DailyCheckinQuestionsRouterInterface
    private var _questions = [RatingQuestionViewModel.Question]()

    // MARK: - Init

    init(worker: DailyCheckinQuestionsWorker,
        presenter: DailyCheckinQuestionsPresenterInterface,
        router: DailyCheckinQuestionsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
        worker.getQuestions { [weak self] (questions) in
            guard let questions = questions else { return }
            self?._questions = questions
            self?.presenter.showQuestions()
        }
    }
}

// MARK: - DailyCheckinQuestionsInteractorInterface

extension DailyCheckinQuestionsInteractor: DailyCheckinQuestionsInteractorInterface {
    var questions: [RatingQuestionViewModel.Question] {
        return _questions
    }

    var answeredQuestionCount: Int {
        return _questions.compactMap({ (question) -> Int? in
            question.selectedAnswerIndex
        }).count
    }

    func saveAnswers() {
        worker.saveAnswers {[weak self] in
            self?.router.dismiss()
        }
    }

    func dismiss() {
        router.dismiss()
    }
}

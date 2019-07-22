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
    }
}

// MARK: - DailyCheckinQuestionsInteractorInterface

extension DailyCheckinQuestionsInteractor: DailyCheckinQuestionsInteractorInterface {
    var questions: [RatingQuestionViewModel.Question] {
        return worker.questions
    }

    func saveAnswers() {
        worker.saveAnswers {[weak self] in
            self?.router.dismiss()
        }
    }
}

//
//  DailyCheckinStartInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 12.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DailyCheckinStartInteractor {

    // MARK: - Properties

    private let worker: DailyCheckinStartWorker
    private let presenter: DailyCheckinStartPresenterInterface
    private let router: DailyCheckinStartRouterInterface

    // MARK: - Init

    init(worker: DailyCheckinStartWorker,
        presenter: DailyCheckinStartPresenterInterface,
        router: DailyCheckinStartRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        worker.getQuestions {[weak self] (questions) in
            guard let firstQuestion = questions?.first else {
                return
            }
            self?.presenter.setupView(title: firstQuestion.dailyPrepTitle, subtitle: firstQuestion.title, buttonTitle: firstQuestion.buttonText)
        }
    }
}

// MARK: - DailyCheckinStartInteractorInterface

extension DailyCheckinStartInteractor: DailyCheckinStartInteractorInterface {
    func showQuestions() {
        guard let questions = worker.questions else { return }
        let finalQuestions = questions.suffix(from: 1)
        router.showQuestions(Array(finalQuestions))
    }
}

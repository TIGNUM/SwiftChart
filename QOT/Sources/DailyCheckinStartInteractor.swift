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
        worker.getQuestion {[weak self] (question) in
            guard let firstQuestion = question else {
                return
            }
            self?.presenter.setupView(title: firstQuestion.dailyPrepTitle, subtitle: firstQuestion.title, buttonTitle: firstQuestion.buttonText)
        }
    }
}

// MARK: - DailyCheckinStartInteractorInterface

extension DailyCheckinStartInteractor: DailyCheckinStartInteractorInterface {
    func showQuestions() {
        router.showQuestions()
    }
}

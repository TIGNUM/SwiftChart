//
//  GuidedStoryInteractor.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class GuidedStoryInteractor {

    // MARK: - Properties
    private let worker: GuidedStoryWorker!
    private let presenter: GuidedStoryPresenterInterface!

    // MARK: - Init
    init(presenter: GuidedStoryPresenterInterface, worker: GuidedStoryWorker) {
        self.presenter = presenter
        self.worker = worker
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - GuidedStoryInteractorInterface
extension GuidedStoryInteractor: GuidedStoryInteractorInterface {
    func didTabNextSurvey() {
        if worker.isLastQuestion {
            worker.loadJourney()
            presenter.showJourney()
        } else {
            worker.didTabNext()
            presenter.loadNextQuestion()
        }
    }

    func didTabNextJourney() {

    }

    func didTabPreviousJourney() {

    }

    func didTabSkipJourney() {

    }
}

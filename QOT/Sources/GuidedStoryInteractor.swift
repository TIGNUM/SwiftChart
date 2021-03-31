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
        worker.getStory { [weak self] (pageCount) in
            self?.presenter.setupView(pageCount: pageCount)
        }
    }
}

// MARK: - GuidedStoryInteractorInterface
extension GuidedStoryInteractor: GuidedStoryInteractorInterface {
    var currentPage: Int {
        return worker.currentPage
    }

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

// MARK: - GuidedStoryJourneyDelegate
extension GuidedStoryInteractor: GuidedStoryJourneyDelegate {
    func didUpdateCollectionViewCurrentIndex(_ index: Int) {
        let newPage = index + worker.surveyPageOffset
        presenter.updatePageIndicator(newPage)
    }
}

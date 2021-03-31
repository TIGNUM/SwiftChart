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

    var currentJourneyIndex: Int {
        return worker.currentJourneyIndex
    }

    var previousButtonJourneyIsHidden: Bool {
        return worker.previousButtonJourneyIsHidden
    }

    func didTapNextSurvey() {
        if worker.isLastQuestion {
            worker.loadJourney()
            presenter.showJourney()
        } else {
            worker.didTapNextSurvey()
            presenter.loadNextQuestion()
        }
    }

    func didTapNextJourney() {
        worker.didTapNextJourney()
        presenter.updatePageIndicator(worker.currentPage)
    }

    func didTapPreviousJourney() {
        worker.didTapPreviousJourney()
        presenter.updatePageIndicator(worker.currentPage)
    }

    func didUpdateJourneyCurrentIndex(_ index: Int) {
        let newPage = worker.updatePageIndex(index)
        presenter.updatePageIndicator(newPage)
    }
}

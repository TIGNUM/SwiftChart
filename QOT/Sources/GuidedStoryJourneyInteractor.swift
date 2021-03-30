//
//  GuidedStoryJourneyInteractor.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class GuidedStoryJourneyInteractor {

    // MARK: - Properties
    private let worker: GuidedStoryWorker!
    private let presenter: GuidedStoryJourneyPresenterInterface!

    // MARK: - Init
    init(presenter: GuidedStoryJourneyPresenterInterface, worker: GuidedStoryWorker) {
        self.presenter = presenter
        self.worker = worker
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        presenter.setupHeaderView(content: worker.targetContent)
    }
}

// MARK: - GuidedStoryJourneyInteractorInterface
extension GuidedStoryJourneyInteractor: GuidedStoryJourneyInteractorInterface {
    var itemCount: Int {
        return worker.storyItems.count
    }

    func body(at index: Int) -> String? {
        return worker.storyItems.at(index: index)?.body
    }
}

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
    private lazy var worker = GuidedStoryJourneyWorker()
    private let presenter: GuidedStoryJourneyPresenterInterface!

    // MARK: - Init
    init(presenter: GuidedStoryJourneyPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - GuidedStoryJourneyInteractorInterface
extension GuidedStoryJourneyInteractor: GuidedStoryJourneyInteractorInterface {

}

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
    private lazy var worker = GuidedStoryWorker()
    private let presenter: GuidedStoryPresenterInterface!

    // MARK: - Init
    init(presenter: GuidedStoryPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - GuidedStoryInteractorInterface
extension GuidedStoryInteractor: GuidedStoryInteractorInterface {

}

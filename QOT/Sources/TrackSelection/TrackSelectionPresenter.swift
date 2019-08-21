//
//  TrackSelectionPresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class TrackSelectionPresenter {

    // MARK: - Properties

    private weak var viewController: TrackSelectionViewControllerInterface?

    // MARK: - Init

    init(viewController: TrackSelectionViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - TrackSelectionInterface

extension TrackSelectionPresenter: TrackSelectionPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}

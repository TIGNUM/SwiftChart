//
//  VisionRatingExplanationPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.08.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class VisionRatingExplanationPresenter {

    // MARK: - Properties
    private weak var viewController: VisionRatingExplanationViewControllerInterface?

    // MARK: - Init
    init(viewController: VisionRatingExplanationViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - VisionRatingExplanationInterface
extension VisionRatingExplanationPresenter: VisionRatingExplanationPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}

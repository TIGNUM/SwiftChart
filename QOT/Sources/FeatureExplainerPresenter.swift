//
//  FeatureExplainerPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.05.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class FeatureExplainerPresenter {

    // MARK: - Properties
    private weak var viewController: FeatureExplainerViewControllerInterface?

    // MARK: - Init
    init(viewController: FeatureExplainerViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - FeatureExplainerInterface
extension FeatureExplainerPresenter: FeatureExplainerPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}

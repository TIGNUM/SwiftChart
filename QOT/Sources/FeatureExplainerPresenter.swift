//
//  FeatureExplainerPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.05.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

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
    func setupView(_ content: QDMContentCollection?, type: FeatureExplainer.Kind?) {
        let viewModel = createModel(content, type: type)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.setupView(viewModel)
        }
    }
}

// MARK: - Private
private extension FeatureExplainerPresenter {
    func createModel(_ content: QDMContentCollection?,
                     type: FeatureExplainer.Kind?) -> FeatureExplainer.ViewModel {
        return FeatureExplainer.ViewModel(title: "", description: "")
    }
}

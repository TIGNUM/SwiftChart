//
//  FeatureExplainerInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.05.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class FeatureExplainerInteractor {

    // MARK: - Properties
    private lazy var worker = FeatureExplainerWorker(contentService: ContentService.main)
    private let presenter: FeatureExplainerPresenterInterface
    private let featureType: FeatureExplainer.Kind

    // MARK: - Init
    init(presenter: FeatureExplainerPresenterInterface, featureType: FeatureExplainer.Kind) {
        self.featureType = featureType
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        worker.getExplainerContent(featureType: featureType) { [weak self] (contentCollection) in
            self?.presenter.setupView(contentCollection, type: self?.featureType)
        }
    }
}

// MARK: - FeatureExplainerInteractorInterface
extension FeatureExplainerInteractor: FeatureExplainerInteractorInterface {

    var getFeatureType: FeatureExplainer.Kind {
        return featureType
    }
}

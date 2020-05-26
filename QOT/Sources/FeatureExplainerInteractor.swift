//
//  FeatureExplainerInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.05.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class FeatureExplainerInteractor {

    // MARK: - Properties
    private let worker: FeatureExplainerWorker
    private let presenter: FeatureExplainerPresenterInterface

    // MARK: - Init
    init(worker: FeatureExplainerWorker, presenter: FeatureExplainerPresenterInterface) {
        self.worker = worker
        self.presenter = presenter        
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - FeatureExplainerInteractorInterface
extension FeatureExplainerInteractor: FeatureExplainerInteractorInterface {

}

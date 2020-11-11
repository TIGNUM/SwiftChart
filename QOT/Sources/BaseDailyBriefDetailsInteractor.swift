//
//  BaseDailyBriefDetailsInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 09/11/2020.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class BaseDailyBriefDetailsInteractor {

    // MARK: - Properties
    private lazy var worker = BaseDailyBriefDetailsWorker(model: model)
    private let presenter: BaseDailyBriefDetailsPresenterInterface!
    let model: BaseDailyBriefViewModel
    
    // MARK: - Init
    init(presenter: BaseDailyBriefDetailsPresenterInterface, model: BaseDailyBriefViewModel) {
        self.presenter = presenter
        self.model = model
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - BaseDailyBriefDetailsInteractorInterface
extension BaseDailyBriefDetailsInteractor: BaseDailyBriefDetailsInteractorInterface {
    func getModel() -> BaseDailyBriefViewModel {
        return self.model
    }
}

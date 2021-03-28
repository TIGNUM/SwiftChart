//
//  GuidedStorySurveyInteractor.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class GuidedStorySurveyInteractor {

    // MARK: - Properties
    private lazy var worker = GuidedStorySurveyWorker()
    private let presenter: GuidedStorySurveyPresenterInterface!

    // MARK: - Init
    init(presenter: GuidedStorySurveyPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - GuidedStorySurveyInteractorInterface
extension GuidedStorySurveyInteractor: GuidedStorySurveyInteractorInterface {

}

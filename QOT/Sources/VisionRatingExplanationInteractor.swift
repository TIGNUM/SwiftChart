//
//  VisionRatingExplanationInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.08.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class VisionRatingExplanationInteractor {

    // MARK: - Properties
    private lazy var worker = VisionRatingExplanationWorker()
    private let presenter: VisionRatingExplanationPresenterInterface!

    // MARK: - Init
    init(presenter: VisionRatingExplanationPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - VisionRatingExplanationInteractorInterface
extension VisionRatingExplanationInteractor: VisionRatingExplanationInteractorInterface {

}

//
//  CoachMarksInteractor.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class CoachMarksInteractor {

    // MARK: - Properties
    private lazy var worker = CoachMarksWorker()
    private let presenter: CoachMarksPresenterInterface

    // MARK: - Init
    init(presenter: CoachMarksPresenterInterface) {
        self.presenter = presenter        
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - CoachMarksInteractorInterface
extension CoachMarksInteractor: CoachMarksInteractorInterface {

}

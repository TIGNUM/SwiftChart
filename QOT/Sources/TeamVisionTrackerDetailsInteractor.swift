//
//  TeamVisionTrackerDetailsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamVisionTrackerDetailsInteractor {

    // MARK: - Properties
    private lazy var worker = TeamVisionTrackerDetailsWorker()
    private let presenter: TeamVisionTrackerDetailsPresenterInterface!

    // MARK: - Init
    init(presenter: TeamVisionTrackerDetailsPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - TeamVisionTrackerDetailsInteractorInterface
extension TeamVisionTrackerDetailsInteractor: TeamVisionTrackerDetailsInteractorInterface {

}

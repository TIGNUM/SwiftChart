//
//  TeamToBeVisionOptionsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamToBeVisionOptionsInteractor {

    // MARK: - Properties
    private lazy var worker = TeamToBeVisionOptionsWorker()
    private let presenter: TeamToBeVisionOptionsPresenterInterface!

    // MARK: - Init
    init(presenter: TeamToBeVisionOptionsPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - TeamToBeVisionOptionsInteractorInterface
extension TeamToBeVisionOptionsInteractor: TeamToBeVisionOptionsInteractorInterface {

}

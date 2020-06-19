//
//  CreateTeamInteractor.swift
//  QOT
//
//  Created by karmic on 19.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class CreateTeamInteractor {

    // MARK: - Properties
    private lazy var worker = CreateTeamWorker()
    private let presenter: CreateTeamPresenterInterface!

    // MARK: - Init
    init(presenter: CreateTeamPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - CreateTeamInteractorInterface
extension CreateTeamInteractor: CreateTeamInteractorInterface {

}

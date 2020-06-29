//
//  MyXTeamSettingsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class MyXTeamSettingsInteractor {

    // MARK: - Properties
    private let worker: MyXTeamSettingsWorker
    private let presenter: MyXTeamSettingsPresenterInterface

    // MARK: - Init
    init(worker: MyXTeamSettingsWorker, presenter: MyXTeamSettingsPresenterInterface) {
        self.worker = worker
        self.presenter = presenter        
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyXTeamSettingsInteractorInterface
extension MyXTeamSettingsInteractor: MyXTeamSettingsInteractorInterface {

}

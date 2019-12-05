//
//  RegisterIntroInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 05/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegisterIntroInteractor {

    // MARK: - Properties
    private lazy var worker = RegisterIntroWorker()
    private let presenter: RegisterIntroPresenterInterface!

    // MARK: - Init
    init(presenter: RegisterIntroPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - RegisterIntroInteractorInterface
extension RegisterIntroInteractor: RegisterIntroInteractorInterface {

}

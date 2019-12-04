//
//  RegisterVideoIntroInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 29/11/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegisterVideoIntroInteractor {

    // MARK: - Properties
    private let worker: RegisterVideoIntroWorker
    private let presenter: RegisterVideoIntroPresenterInterface

    // MARK: - Init
    init(worker: RegisterVideoIntroWorker, presenter: RegisterVideoIntroPresenterInterface) {
        self.worker = worker
        self.presenter = presenter        
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }

    func didTapBack() {
//        delegate?.didTapBack()
    }
}

// MARK: - RegisterVideoIntroInteractorInterface
extension RegisterVideoIntroInteractor: RegisterVideoIntroInteractorInterface {

}

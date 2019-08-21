//
//  MyDataExplanationInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyDataExplanationInteractor {

    // MARK: - Properties
    private let worker: MyDataExplanationWorker
    private let presenter: MyDataExplanationPresenterInterface

    // MARK: - Init
    init(worker: MyDataExplanationWorker, presenter: MyDataExplanationPresenterInterface) {
        self.worker = worker
        self.presenter = presenter        
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyDataExplanationInteractorInterface
extension MyDataExplanationInteractor: MyDataExplanationInteractorInterface {

}

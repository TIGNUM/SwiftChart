//
//  MyDataSelectionInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyDataSelectionInteractor {

    // MARK: - Properties
    private let worker: MyDataSelectionWorker
    private let presenter: MyDataSelectionPresenterInterface

    // MARK: - Init
    init(worker: MyDataSelectionWorker, presenter: MyDataSelectionPresenterInterface) {
        self.worker = worker
        self.presenter = presenter        
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyDataSelectionInteractorInterface
extension MyDataSelectionInteractor: MyDataSelectionInteractorInterface {

}

//
//  ShifterResultInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ShifterResultInteractor {

    // MARK: - Properties
    private let worker: ShifterResultWorker
    private let presenter: ShifterResultPresenterInterface

    // MARK: - Init
    init(worker: ShifterResultWorker, presenter: ShifterResultPresenterInterface) {
        self.worker = worker
        self.presenter = presenter        
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        presenter.load(worker.getMindsetShifterResultModel())
    }
}

// MARK: - ShifterResultInteractorInterface
extension ShifterResultInteractor: ShifterResultInteractorInterface {}

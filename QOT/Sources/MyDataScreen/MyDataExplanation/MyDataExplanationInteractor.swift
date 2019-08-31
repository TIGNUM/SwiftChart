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
    let presentedFromSection: MyDataSection

    // MARK: - Init
    init(worker: MyDataExplanationWorker, presenter: MyDataExplanationPresenterInterface, presentedFromSection: MyDataSection) {
        self.worker = worker
        self.presenter = presenter
        self.presentedFromSection = presentedFromSection
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.present(for: worker.myDataExplanationSections(), myDataExplanationHeaderTitle: worker.myDataExplanationHeaderTitle())
        presenter.setupView()
    }
}

// MARK: - MyDataExplanationInteractorInterface
extension MyDataExplanationInteractor: MyDataExplanationInteractorInterface {
    func getPresentedFromSection() -> MyDataSection {
        return presentedFromSection
    }
}

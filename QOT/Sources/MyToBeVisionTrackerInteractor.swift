//
//  MyToBeVisionTrackerInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyToBeVisionTrackerInteractor {

    // MARK: - Properties

    private let worker: MyToBeVisionTrackerWorker
    private let presenter: MyToBeVisionTrackerPresenterInterface
    let dispatchGroup = DispatchGroup()

    // MARK: - Init

    init(worker: MyToBeVisionTrackerWorker,
        presenter: MyToBeVisionTrackerPresenterInterface) {
        self.worker = worker
        self.presenter = presenter
    }
}

// MARK: - MyToBeVisionTrackerInteractorInterface

extension MyToBeVisionTrackerInteractor: MyToBeVisionTrackerInteractorInterface {
    func setSelection(for date: Date?) -> MYTBVDataViewModel? {
        return worker.setSelection(for: date)
    }

    var controllerType: MyToBeVisionTrackerWorker.ControllerType {
        return worker.controllerType
    }

    func viewDidLoad() {
        worker.getData {[weak self] (report) in
            guard let model = report else { return }
            self?.presenter.setupView(with: model)
        }
    }
}

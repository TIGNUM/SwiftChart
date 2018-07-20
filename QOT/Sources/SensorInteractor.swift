//
//  SensorInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 17/07/2018.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SensorInteractor {

    // MARK: - Properties

    private let worker: SensorWorker
    private let presenter: SensorPresenterInterface
    private let router: SensorRouterInterface

    // MARK: - Init

    init(worker: SensorWorker, presenter: SensorPresenterInterface, router: SensorRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        guard
            let sensors = worker.sensors(),
            let headline = worker.headline(),
            let content = worker.content() else { return }
        presenter.setup(sensors: sensors, headline: headline, content: content)
    }
}

// MARK: - SensorInteractorInterface

extension SensorInteractor: SensorInteractorInterface {

    func didTapSensor(sensor: SensorModel) {
        router.didTapSensor(sensor: sensor, settingValue: worker.settingValue(), completion: { feedback in
            self.worker.recordFeedback(message: feedback)
        })
    }
}

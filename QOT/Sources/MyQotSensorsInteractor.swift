//
//  MyQotSensorsInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSensorsInteractor {
    // MARK: - Properties

    private let worker: MyQotSensorsWorker
    private let presenter: MyQotSensorsPresenterInterface
    private let router: MyQotSensorsRouterInterface

    // MARK: - Init

    init(worker: MyQotSensorsWorker, presenter: MyQotSensorsPresenterInterface, router: MyQotSensorsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    var requestTracker: MyQotSensorsModel {
        return MyQotSensorsModel(sensor: .requestTracker)
    }
}

// MARK: - Interactor

extension MyQotSensorsInteractor: MyQotSensorsInteractorInterface {

    func viewDidLoad() {
        presenter.setupView()
        presenter.setOuraRing(title: worker.ouraSensor.sensor.title,
                              status: worker.ouraSensor.sensor.status,
                              labelStatus: worker.ouraSensor.sensor.labelStatus)
        presenter.setHealthKit(title: worker.healthKitSensor.sensor.title,
                               status: worker.healthKitSensor.sensor.status,
                               labelStatus: worker.healthKitSensor.sensor.labelStatus)
        presenter.setSensor(title: worker.headline() ?? "", description: worker.content() ?? "")
        presenter.set(headerTitle: worker.headerTitle, sensorTitle: worker.sensorTitle, requestTrackerTitle: worker.requestTrackerTitle)
    }

    func didTapSensor(sensor: MyQotSensorsModel) {
        router.didTapSensor(sensor: sensor, settingValue: nil, completion: {[weak self] feedback in
            self?.worker.recordFeedback(message: feedback)
        })
    }
}

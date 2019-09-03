//
//  MyQotSensorsInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal
import HealthKit

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
    func handleOuraRingAuthResultURL(url: URL, ouraRingAuthConfiguration: QDMOuraRingConfig?) {
        worker.handleOuraRingAuthResultURL(url: url,
                                           ouraRingAuthConfiguration: ouraRingAuthConfiguration) { [weak self] (tracker) in
                                            self?.updateOuraStatus()
        }
    }

    func requestHealthKitAuthorization() {
        worker.requestHealthKitAuthorization { [weak self] (authorized) in
            if authorized == true {
                self?.updateHealthKitStatus()
                self?.worker.importHealthKitData()
            }
        }
    }

    func requestAuraAuthorization() {
        worker.requestAuraAuthorization { [weak self] (tracker, config) in
            if let oauthConfig = config, let requestURL = oauthConfig.authRequestURL() {
                self?.router.startOuraAuth(requestURL: requestURL, config: oauthConfig)
            }
        }
    }

    func viewDidLoad() {
        presenter.setupView()
        updateOuraStatus()
        updateHealthKitStatus()
        worker.headline {[weak self] (headline) in
            self?.worker.content({[weak self]  (content) in
                self?.presenter.setSensor(title: headline ?? "", description: content ?? "")
            })
        }

        worker.headerTitle {[weak self]  (workerText) in
            self?.worker.sensorTitle({[weak self]  (sensorText) in
                self?.presenter.set(headerTitle: workerText, sensorTitle: sensorText)
            })
        }
    }
}

private extension MyQotSensorsInteractor {
    func updateHealthKitStatus() {
        var status: String = R.string.localized.sidebarSensorsMenuSensorsDisconnected()
        var buttonEnabled = false
        switch worker.getHealthKitAuthStatus() {
        case .notDetermined:
            status = R.string.localized.sidebarSensorsMenuSensorsDisconnected()
            buttonEnabled = true
        default:
            status = R.string.localized.sidebarSensorsMenuSensorsConnected()
            HealthService.main.hasSleepData(from: Date().dateAfterYears(-1), to: Date()) { [weak self] (hasData) in
                    status = hasData ? R.string.localized.sidebarSensorsMenuSensorsConnected() : R.string.localized.sidebarSensorsMenuSensorsNoData()
                self?.presenter.setHealthKit(title: self?.worker.healthKitSensor.sensor.title ?? "",
                                       status: status,
                                       labelStatus: self?.worker.healthKitSensor.sensor.labelStatus ?? "",
                                       buttonEnabled: buttonEnabled)
            }
        }
    }

    func updateOuraStatus() {
        worker.getOuraRingAuthStatus { [weak self] (authorized) in
            var status = R.string.localized.sidebarSensorsMenuSensorsDisconnected()
            if authorized == true {
                status = R.string.localized.sidebarSensorsMenuSensorsConnected()
            }
            self?.presenter.setOuraRing(title: self?.worker.ouraSensor.sensor.title ?? "",
                                        status: status,
                                        labelStatus: self?.worker.ouraSensor.sensor.labelStatus ?? "")
        }
    }
}

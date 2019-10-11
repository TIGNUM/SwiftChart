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

    private var localizedSensorsConnected: String {
        return AppTextService.get(AppTextKey.my_qot_sensors_menu_connected_title)
    }

    private var localizedSensorsDisconnected: String {
        return AppTextService.get(AppTextKey.my_qot_sensors_menu_disconnected_title)
    }

    private var localizedSensorsNoData: String {
        return AppTextService.get(AppTextKey.my_qot_sensors_menu_no_data_title)
    }

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
        switch worker.getHealthKitAuthStatus() {
        case .notDetermined:
            worker.requestHealthKitAuthorization { [weak self] (authorized) in
                if authorized == true {
                    self?.updateHealthKitStatus()
                    self?.worker.importHealthKitData()
                }
            }
        default:
            UIApplication.shared.open(URL(string: "x-apple-health://")!)
        }
    }

    func requestAuraAuthorization() {
        worker.requestAuraAuthorization { [weak self] (tracker, config) in
            if let oauthConfig = config, let requestURL = oauthConfig.authRequestURL() {
                self?.router.startOuraAuth(requestURL: requestURL, config: oauthConfig)
            }
        }
    }

    func updateHealthKitStatus() {
        var status: String = localizedSensorsDisconnected
        switch worker.getHealthKitAuthStatus() {
        case .notDetermined:
            status = localizedSensorsDisconnected
            self.presenter.setHealthKit(title: self.worker.healthKitSensor.sensor.title,
                                        status: status,
                                        showNoDataInfo: false,
                                        buttonEnabled: true)
        default:
            status = localizedSensorsConnected
            HealthService.main.hasSleepData(from: Date().dateAfterYears(-1), to: Date()) { [weak self] (hasData) in
                guard let strongSelf = self else { return }
                status = hasData ? strongSelf.localizedSensorsConnected : strongSelf.localizedSensorsNoData
                DispatchQueue.main.async {
                    strongSelf.presenter.setHealthKit(title: strongSelf.worker.healthKitSensor.sensor.title,
                                                 status: status,
                                                 showNoDataInfo: !hasData,
                                                 buttonEnabled: !hasData)
                }
            }
        }
    }

    func viewDidLoad() {
        presenter.setupView()
        updateOuraStatus()
        updateHealthKitStatus()
        worker.headlineHealthKit { [weak self] (headlineHealthKit) in
            self?.worker.contentHealthKit { (contentHealthKit) in
                self?.presenter.setHealthKitDescription(title: headlineHealthKit ?? "",
                                                        description: contentHealthKit ?? "")
            }
        }
        worker.headlineOuraRing { [weak self] (headlineOuraRing) in
            self?.worker.contentOuraRing { (contentOuraRing) in
                self?.presenter.setOuraRingDescription(title: headlineOuraRing ?? "",
                                                       description: contentOuraRing ?? "")
            }
        }
        presenter.set(headerTitle: worker.headerTitle, sensorTitle: worker.sensorTitle)
    }
}

private extension MyQotSensorsInteractor {
    func updateOuraStatus() {
        worker.getOuraRingAuthStatus { [weak self] (authorized) in
            guard let strongSelf = self else { return }
            let status = authorized ? strongSelf.localizedSensorsConnected : strongSelf.localizedSensorsDisconnected
            strongSelf.presenter.setOuraRing(title: strongSelf.worker.ouraSensor.sensor.title,
                                        status: status,
                                        labelStatus: strongSelf.worker.ouraSensor.sensor.labelStatus)
        }
    }
}

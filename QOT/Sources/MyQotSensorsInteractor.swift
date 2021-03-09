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
        return AppTextService.get(.my_qot_my_profile_app_settings_data_sources_section_sensors_button_connect)
    }

    private var localizedSensorsDisconnected: String {
        return AppTextService.get(.my_qot_my_profile_app_settings_data_sources_section_sensors_button_disconnect)
    }

    private var localizedSensorsNoData: String {
        return AppTextService.get(.my_qot_my_profile_app_settings_data_sources_section_sensors_button_no_data)
    }

    // MARK: - Init
    init(worker: MyQotSensorsWorker, presenter: MyQotSensorsPresenterInterface, router: MyQotSensorsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }
}

// MARK: - Interactor
extension MyQotSensorsInteractor: MyQotSensorsInteractorInterface {
    func handleOuraRingAuthResultURL(url: URL, ouraRingAuthConfiguration: QDMOuraRingConfig?) {
        worker.handleOuraRingAuthResultURL(url: url,
                                           ouraRingAuthConfiguration: ouraRingAuthConfiguration) { [weak self] (_) in
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
        worker.requestAuraAuthorization { [weak self] (_, config) in
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
                                        showNoDataInfo: false)
        default:
            status = localizedSensorsConnected
            HealthService.main.hasSleepData(from: Date().dateAfterYears(-1), to: Date()) { [weak self] (hasData) in
                guard let strongSelf = self else { return }
                status = hasData ? strongSelf.localizedSensorsConnected : strongSelf.localizedSensorsNoData
                DispatchQueue.main.async {
                    strongSelf.presenter.setHealthKit(title: strongSelf.worker.healthKitSensor.sensor.title,
                                                 status: status,
                                                 showNoDataInfo: !hasData)
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
                self?.presenter.setHealthKitDescription(title: headlineHealthKit ?? String.empty,
                                                        description: contentHealthKit ?? String.empty)
            }
        }
        worker.headlineOuraRing { [weak self] (headlineOuraRing) in
            self?.worker.contentOuraRing { (contentOuraRing) in
                self?.presenter.setOuraRingDescription(title: headlineOuraRing ?? String.empty,
                                                       description: contentOuraRing ?? String.empty)
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

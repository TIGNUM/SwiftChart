//
//  MyQotSensorsInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal
import HealthKit

protocol MyQotSensorsViewControllerInterface: class {
    func setupView()
    func set(headerTitle: String, sensorTitle: String)
    func setHealthKit(title: String, status: String, showNoDataInfo: Bool, buttonEnabled: Bool)
    func setOuraRing(title: String, status: String, labelStatus: String)
    func setHealthKitDescription(title: String, description: String)
    func setOuraRingDescription(title: String, description: String)
}

protocol MyQotSensorsPresenterInterface {
    func setupView()
    func set(headerTitle: String, sensorTitle: String)
    func setHealthKit(title: String, status: String, showNoDataInfo: Bool, buttonEnabled: Bool)
    func setOuraRing(title: String, status: String, labelStatus: String)
    func setHealthKitDescription(title: String, description: String)
    func setOuraRingDescription(title: String, description: String)
}

protocol MyQotSensorsInteractorInterface: Interactor {
    func requestHealthKitAuthorization()
    func requestAuraAuthorization()
    func handleOuraRingAuthResultURL(url: URL, ouraRingAuthConfiguration: QDMOuraRingConfig?)
    func updateHealthKitStatus()
}

protocol MyQotSensorsRouterInterface {
    func startOuraAuth(requestURL: URL, config: QDMOuraRingConfig)
}

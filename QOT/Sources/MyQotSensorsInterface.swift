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
    func setHealthKit(title: String, status: String, labelStatus: String, buttonEnabled: Bool)
    func setOuraRing(title: String, status: String, labelStatus: String)
    func setSensor(title: String, description: String)
}

protocol MyQotSensorsPresenterInterface {
    func setupView()
    func set(headerTitle: String, sensorTitle: String)
    func setHealthKit(title: String, status: String, labelStatus: String, buttonEnabled: Bool)
    func setOuraRing(title: String, status: String, labelStatus: String)
    func setSensor(title: String, description: String)
}

protocol MyQotSensorsInteractorInterface: Interactor {
    func requestHealthKitAuthorization()
    func requestAuraAuthorization()
    func handleOuraRingAuthResultURL(url: URL, ouraRingAuthConfiguration: QDMOuraRingConfig?)
}

protocol MyQotSensorsRouterInterface {
    func startOuraAuth(requestURL: URL, config: QDMOuraRingConfig)
}

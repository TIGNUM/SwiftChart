//
//  MyQotSensorsInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotSensorsViewControllerInterface: class {
    func setupView()
    func set(headerTitle: String, sensorTitle: String, requestTrackerTitle: String)
    func setHealthKit(title: String, status: String, labelStatus: String)
    func setOuraRing(title: String, status: String, labelStatus: String)
    func setSensor(title: String, description: String)
}

protocol MyQotSensorsPresenterInterface {
    func setupView()
    func set(headerTitle: String, sensorTitle: String, requestTrackerTitle: String)
    func setHealthKit(title: String, status: String, labelStatus: String)
    func setOuraRing(title: String, status: String, labelStatus: String)
    func setSensor(title: String, description: String)
}

protocol MyQotSensorsInteractorInterface: Interactor {
    var requestTracker: MyQotSensorsModel { get }
    func didTapSensor(sensor: MyQotSensorsModel)
}

protocol MyQotSensorsRouterInterface {
    func didTapSensor(sensor: MyQotSensorsModel, settingValue: SettingValue?, completion: @escaping (String) -> Void?)
}



//
//  SensorInterface.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 17/07/2018.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

protocol SensorViewControllerInterface: class {
    func setup(sensors: [SensorModel], headline: String, content: String)
    func reload()
}

protocol SensorPresenterInterface {
    func setup(sensors: [SensorModel], headline: String, content: String)
}

protocol SensorInteractorInterface: Interactor {
    func didTapSensor(sensor: SensorModel)
}

protocol SensorRouterInterface {
    func didTapSensor(sensor: SensorModel, settingValue: SettingValue?, completion: @escaping (String) -> Void?)
}

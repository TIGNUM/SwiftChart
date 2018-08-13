//
//  AppDelegate+PredictIO.swift
//  QOT
//
//  Created by karmic on 27.07.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import PredictIO

extension AppDelegate {

    private var apiKeyPredictIO: String {
        return "03dcd6d60cd01d5335d854f19207e7bbd91f325bd416e1873c1a072540a77f92"
    }

    private func predictIONotify(webHookURL: String, customParameters: [String: String]) {
        PredictIO.notify(on: .arrival) { event in
            log("PredictIO.notify.event: \(event.type, event.description)", level: .error)
        }

        PredictIO.notify(on: .departure) { event in
            log("PredictIO.notify.event: \(event.type, event.description)", level: .error)
        }

        PredictIO.notify(on: .enroute) { event in
            log("PredictIO.notify.event: \(event.type, event.description)", level: .error)
        }

        PredictIO.notify(on: .still) { event in
            log("PredictIO.notify.event: \(event.type, event.description)", level: .error)
        }

        PredictIO.setWebhookURL(webHookURL)
        customParameters.forEach { (key, value) in
            PredictIO.setCustomParameter(key: key, value: value)
        }
    }

    func setupPredictIO(webHookURL: String, customParameters: [String: String]) {
        PredictIO.start(apiKey: apiKeyPredictIO, powerLevel: .highPower) { [weak self] status in
            switch status {
            case .invalidKey:
                log("PredictIO - Invalid API Key: \(status.localizedDescription)", level: .error)
            case .killSwitch:
                log("PredictIO - Kill switch is active: \(status.localizedDescription)", level: .error)
            case .wifiDisabled:
                log("PredictIO - WiFi is turned off: \(status.localizedDescription)", level: .error)
            case .locationPermissionNotDetermined:
                log("PredictIO - Location permission: not yet determined: \(status.localizedDescription)", level: .error)
            case .locationPermissionRestricted: log("Invalid API Key: \(status.localizedDescription)", level: .error)
                log("PredictIO - Location permission: restricted: \(status.localizedDescription)", level: .error)
            case .locationPermissionWhenInUse:
                log("PredictIO - Location permission: when in use: \(status.localizedDescription)", level: .error)
            case .locationPermissionDenied:
                log("PredictIO - Location permission: denied: \(status.localizedDescription)", level: .error)
            case .success:
                log("PredictIO - Successfully started PredictIO SDK!: \(status.localizedDescription)", level: .error)
            }
            self?.predictIONotify(webHookURL: webHookURL, customParameters: customParameters)
        }
    }
}

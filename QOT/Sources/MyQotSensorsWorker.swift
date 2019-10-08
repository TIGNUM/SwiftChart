//
//  MyQotSensorsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal
import HealthKit

final class MyQotSensorsWorker {

    // MARK: - Properties
    private let contentService: qot_dal.ContentService
    var ouraRingAuthConfiguration: QDMOuraRingConfig?

    // MARK: - Init
    init(contentService: qot_dal.ContentService) {
        self.contentService = contentService
    }

    // MARK: - Actions
    var ouraSensor: MyQotSensorsModel {
        return MyQotSensorsModel(sensor: .oura)
    }

    var healthKitSensor: MyQotSensorsModel {
        return MyQotSensorsModel(sensor: .healthKit)
    }

    var requestTracker: MyQotSensorsModel {
        return MyQotSensorsModel(sensor: .requestTracker)
    }

    func headline(_ completion: @escaping(String?) -> Void) {
        // FIXME: find better way instead of using id.
        contentService.getContentItemById(107863) { (contentItem) in
            completion(contentItem?.valueText)
        }
    }

    func content(_ completion: @escaping(String?) -> Void) {
        // FIXME: find better way instead of using id.
        contentService.getContentItemById(107860) { (contentItem) in
            completion(contentItem?.valueText)
        }
    }

    var headerTitle: String {
        return ScreenTitleService.main.localizedString(for: .MyQotTrackerActivityTrackers)
    }

    var sensorTitle: String {
        return ScreenTitleService.main.localizedString(for: .MyQotTrackerSensors)
    }
}

// MARK: - HealthKit
extension MyQotSensorsWorker {
    func requestHealthKitAuthorization(_ completion: @escaping (Bool) -> Void) {
        HealthService.main.requestHealthKitAuthorization { (success, error) in
            if let error = error {
                qot_dal.log("Error requestHealthKitAuthorization: \(error.localizedDescription)", level: .error)
            }
            completion(success)
        }
    }

    func getHealthKitAuthStatus() -> HKAuthorizationStatus {
        return qot_dal.HealthService.main.healthKitAuthorizationStatus()
    }

    func importHealthKitData() {
        if HealthService.main.isHealthDataAvailable() == true {
            HealthService.main.importHealthKitSleepAnalysisData()
        }
    }
}

// MARK: - Oura
extension MyQotSensorsWorker {
    func requestAuraAuthorization(_ completion: @escaping (QDMHealthTracker?, QDMOuraRingConfig?) -> Void) {
        HealthService.main.ouraRingAuthStatus(completion)
    }

    func getOuraRingAuthStatus(_ completion: @escaping (Bool) -> Void) {
        HealthService.main.ouraRingAuthStatus { (tracker, config) in
            completion(tracker?.authenticationSuccessful ?? false)
        }
    }

    func handleOuraRingAuthResultURL(url: URL,
                                     ouraRingAuthConfiguration: QDMOuraRingConfig?,
                                     completion: @escaping (QDMHealthTracker?) -> Void) {
        HealthService.main.handleOuraRingAuthResultURL(url, config: ouraRingAuthConfiguration) { (tracker, error) in
            if let error = error {
                qot_dal.log("Error handleOuraRingAuthResultURL: \(error)", level: .error)
            }
            completion(tracker)
        }
    }
}

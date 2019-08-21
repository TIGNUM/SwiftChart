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
        contentService.getContentCollectionById(100935) { (collection) in
            let item = collection?.contentItems.filter({ $0.format == .header2 }).first?.valueText
            completion(item)
        }
    }

    func content(_ completion: @escaping(String?) -> Void) {
        contentService.getContentCollectionById(100935) { (collection) in
            let item = collection?.contentItems.filter({ $0.format == .paragraph }).first?.valueText
            completion(item)
        }
    }

    func headerTitle(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.Sensors.activityTrackers.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func sensorTitle(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.Sensors.sensors.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
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

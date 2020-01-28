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
    private let contentService: ContentService
    var ouraRingAuthConfiguration: QDMOuraRingConfig?

    // MARK: - Init
    init(contentService: ContentService) {
        self.contentService = contentService
    }

    // MARK: - Actions
    var ouraSensor: MyQotSensorsModel {
        return MyQotSensorsModel(sensor: .oura)
    }

    var healthKitSensor: MyQotSensorsModel {
        return MyQotSensorsModel(sensor: .healthKit)
    }

    func headlineHealthKit(_ completion: @escaping(String?) -> Void) {
        // FIXME: find better way instead of using id.
        contentService.getContentItemById(107863) { (contentItem) in
            completion(contentItem?.valueText)
        }
    }

    func contentHealthKit(_ completion: @escaping(String?) -> Void) {
        // FIXME: find better way instead of using id.
        contentService.getContentItemById(107860) { (contentItem) in
            completion(contentItem?.valueText)
        }
    }

    func headlineOuraRing(_ completion: @escaping(String?) -> Void) {
        // FIXME: find better way instead of using id.
        contentService.getContentItemById(107872) { (contentItem) in
            completion(contentItem?.valueText)
        }
    }

    func contentOuraRing(_ completion: @escaping(String?) -> Void) {
        // FIXME: find better way instead of using id.
        contentService.getContentItemById(107873) { (contentItem) in
            completion(contentItem?.valueText)
        }
    }

    var headerTitle: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_data_sources_section_header_title)
    }

    var sensorTitle: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_data_sources_section_sensors_title_sensor)
    }
}

// MARK: - HealthKit
extension MyQotSensorsWorker {
    func requestHealthKitAuthorization(_ completion: @escaping (Bool) -> Void) {
        HealthService.main.requestHealthKitAuthorization { (success, error) in
            if let error = error {
                log("Error requestHealthKitAuthorization: \(error.localizedDescription)", level: .error)
            }
            completion(success)
        }
    }

    func getHealthKitAuthStatus() -> HKAuthorizationStatus {
        return HealthService.main.healthKitAuthorizationStatus()
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
                log("Error handleOuraRingAuthResultURL: \(error)", level: .error)
            }
            completion(tracker)
        }
    }
}

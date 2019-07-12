//
//  MyQotSensorsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotSensorsWorker {

    // MARK: - Properties

    private let contentService: qot_dal.ContentService

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

//
//  MyQotSensorsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSensorsWorker {

    // MARK: - Properties

    private let services: Services
    private var sensorCollection: ContentCollection? {
        return services.contentService.contentCollection(id: 100935)
    }

    // MARK: - Init

    init(services: Services) {
        self.services = services
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

    func headline() -> String? {
        guard let collection = sensorCollection else { return nil }
        return Array(collection.articleItems).filter { $0.format == ContentItemTextStyle.h2.rawValue }.first?.valueText
    }

    func content() -> String? {
        guard let collection = sensorCollection else { return nil }
        return Array(collection.articleItems).filter { $0.format == ContentItemTextStyle.paragraph.rawValue }.first?.valueText
    }

    func recordFeedback(message: String) {
        do {
            try self.services.feedbackService.recordFeedback(message: message)
        } catch {
            log(error.localizedDescription, level: .error)
        }
    }

    var headerTitle: String {
        return services.contentService.localizedString(for: ContentService.Sensors.activityTrackers.predicate) ?? ""
    }

    var sensorTitle: String {
        return services.contentService.localizedString(for: ContentService.Sensors.sensors.predicate) ?? ""
    }

    var requestTrackerTitle: String {
        return services.contentService.localizedString(for: ContentService.Sensors.requestActivityTracker.predicate) ?? ""
    }
}

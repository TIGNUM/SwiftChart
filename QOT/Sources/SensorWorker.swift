//
//  SensorWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 17/07/2018.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SensorWorker {

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

    func sensors() -> [SensorModel]? {
        return [SensorModel(state: fitbitState(), sensor: .fitbit),
                SensorModel(state: nil, sensor: .requestDevice)]
    }

    func headline() -> String? {
        guard let collection = sensorCollection else { return nil }
        return Array(collection.articleItems).filter { $0.format == ContentItemTextStyle.h2.rawValue }.first?.valueText
    }

    func content() -> String? {
        guard let collection = sensorCollection else { return nil }
        return Array(collection.articleItems).filter { $0.format == ContentItemTextStyle.paragraph.rawValue }.first?.valueText
    }

    func fitbitState() -> User.FitbitState {
        return services.userService.fitbitState
    }

    func settingValue() -> SettingValue? {
        return services.settingsService.settingValue(key: "b2b.fitbit.authorizationurl")
    }

    func recordFeedback(message: String) {
        do {
            try self.services.feedbackService.recordFeedback(message: message)
        } catch {
            log(error.localizedDescription, level: .error)
        }
    }
}

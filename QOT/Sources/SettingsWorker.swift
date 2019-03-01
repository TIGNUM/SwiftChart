//
//  SettingsWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 26/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class SettingsWorker {

    // MARK: - Properties

    private let services: Services

    // MARK: - Init

    init(services: Services) {
        self.services = services
        NotificationCenter.default.post(Notification(name: .startSyncCalendarRelatedData))
    }

    // MARK: - Actions

    func settings() -> SettingsModel {
        return SettingsModel(services: services)
    }
}

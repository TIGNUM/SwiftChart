//
//  SettingsWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 26/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class SettingsWorker {

    private let services: Services

    init(services: Services) {
        self.services = services
    }

    func settings() -> SettingsModel {
        return SettingsModel(services: services)
    }
}

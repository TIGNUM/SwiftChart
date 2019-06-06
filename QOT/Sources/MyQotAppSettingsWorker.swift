//
//  MyQotAppSettingsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAppSettingsWorker {

    private let services: Services

    // MARK: - Init

    init(services: Services) {
        self.services = services
    }

    func settings() -> MyQotAppSettingsModel {
        return MyQotAppSettingsModel(services: services)
    }
}

extension MyQotAppSettingsWorker {
    var appSettingsText: String {
        return services.contentService.localizedString(for: ContentService.MyQot.Profile.appSettings.predicate) ?? ""
    }
}

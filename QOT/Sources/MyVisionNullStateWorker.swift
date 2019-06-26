//
//  MyVisionNullStateWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 19.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyVisionNullStateWorker {

    private let services: Services

    init(services: Services) {
        self.services = services
    }

    var headlinePlaceholder: String? {
        return services.contentService.toBeVisionHeadlinePlaceholder()?.uppercased()
    }

    var messagePlaceholder: String? {
        return services.contentService.toBeVisionMessagePlaceholder()
    }
}

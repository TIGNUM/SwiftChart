//
//  PartnersLandingPageWorker.swift
//  QOT
//
//  Created by karmic on 09.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class PartnersLandingPageWorker {

    // MARK: - Properties

    private let services: Services

    // MARK: - Init

    init(services: Services) {
        self.services = services
    }

    var landingPageDefaults: PartnersLandingPage {
        return services.contentService.partnersLandingPage()
    }
}

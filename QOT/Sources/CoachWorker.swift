//
//  CoachWorker.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class CoachWorker {

    // MARK: - Properties

    private let services: Services

    // MARK: - Init

    init(services: Services) {
        self.services = services
    }

    // MARK: - Functions

    func coachSections() -> CoachModel {
        let headerTitle = services.contentService.coachHeaderTitle()
        let headerSubtitle = services.contentService.coachHeaderSubtitle()
        let coachItems =  CoachSection.allCases.map {
            return CoachModel.Item(coachSections: $0,
                                   title: services.contentService.coachSectionTitles(for: $0),
                                   subtitle: services.contentService.coachSectionSubtitles(for: $0)) }
        return CoachModel(headerTitle: headerTitle, headerSubtitle: headerSubtitle, coachItems: coachItems)
    }
}

//
//  WidgetDataManager.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 13/07/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

enum ExtensionDataType {
    case toBeVision
    case upcomingEvent
    case all
}

final class ExtensionsDataManager {

    // MARK: - Properties

    private let services: Services

    // MARK: - Init

    init(services: Services) {
        self.services = services
    }

    // MARK: - Update cases

    func update(_ dataType: ExtensionDataType) {
        switch dataType {
        case .toBeVision:
            updateToBeVision()
        case .upcomingEvent:
            updateUpcomingEvents()
        case .all:
            updateAll()
        }
    }

    static func didUserLogIn(_ isLogedIn: Bool) {
        ExtensionUserDefaults.setIsUserSignedIn(value: isLogedIn)
    }
}

// MARK: - Private

private extension ExtensionsDataManager {

    func updateToBeVision() {
        let vision = services.userService.myToBeVision()
        let sharedVision = ExtensionModel.ToBeVision(headline: vision?.headline,
                                                     text: vision?.text,
                                                     imageURL: vision?.imageURL)
        ExtensionUserDefaults.set(sharedVision, for: .toBeVision)
    }

    func updateUpcomingEvents() {
        let events = Array(services.preparationService
            .preparations()
            .filter { $0.eventStartDate?.isPast == false })
            .sorted { $0.eventStartDate ?? Date() < $1.eventStartDate ?? Date() }
            .map { preparation in
                return ExtensionModel.UpcomingEvent(localID: preparation.localID,
                                                    eventName: preparation.name,
                                                    startDate: preparation.eventStartDate,
                                                    endDate: preparation.eventEndDate,
                                                    numberOfTasks: preparation.checkableItems.count,
                                                    tasksCompleted: preparation.coveredChecks.count)
        }
        ExtensionUserDefaults.set(events, for: .upcomingEvents)
    }

    func updateAll() {
        updateToBeVision()
        updateUpcomingEvents()
    }
}

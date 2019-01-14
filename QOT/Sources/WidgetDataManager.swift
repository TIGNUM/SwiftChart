//
//  WidgetDataManager.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 13/07/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

enum WidgetData {
    case toBeVision
    case upcomingEvent
    case all
}

final class WidgetDataManager {

    // MARK: - Properties

    private let services: Services

    // MARK: - Init

    init(services: Services) {
        self.services = services
    }

    // MARK: - Update cases

    func update(_ widgetData: WidgetData) {
        switch widgetData {
        case .toBeVision:
            updateToBeVision()
        case .upcomingEvent:
            updateUpcomingEvent()
        case .all:
            updateAll()
        }
    }

    static func didUserLogIn(_ isLogedIn: Bool) {
        WidgetUserDefaults.setIsUserSignedIn(value: isLogedIn)
    }
}

// MARK: - Private

private extension WidgetDataManager {

    func updateToBeVision() {
        let vision = services.userService.myToBeVision()
        WidgetUserDefaults.setToBeVision(headline: vision?.headline,
                                         text: vision?.text,
                                         url: vision?.imageURL)
    }

    func updateUpcomingEvent() {
        let event = services.preparationService.preparations().first(where: { $0.eventStartDate?.isPast == false })
        WidgetUserDefaults.setUpcomingEvent(name: event?.name,
                                            date: event?.eventStartDate,
                                            numberOfTasks: event?.checkableItems.count,
                                            tasksCompleted: event?.coveredChecks.count)
    }

    func updateAll() {
        updateToBeVision()
        updateUpcomingEvent()
    }
}

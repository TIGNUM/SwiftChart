//
//  CalendarEventSelectionRouter.swift
//  QOT
//
//  Created by karmic on 06.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

final class CalendarEventSelectionRouter {

    // MARK: - Properties
    private weak var viewController: CalendarEventSelectionViewController?

    // MARK: - Init
    init(viewController: CalendarEventSelectionViewController?) {
        self.viewController = viewController
    }
}

// MARK: - CalendarEventSelectionRouterInterface
extension CalendarEventSelectionRouter: CalendarEventSelectionRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func presentEditEventController(_ calendarToggleIdentifiers: [String]) {
        let eventEditVC = EKEventEditViewController()
        eventEditVC.eventStore = EKEventStore.shared
        eventEditVC.editViewDelegate = viewController
        eventEditVC.event = EKEvent(eventStore: EKEventStore.shared)
        eventEditVC.event?.calendar = EKEventStore.shared.calendars(for: .event).filter { // mutable & not subscribed
            calendarToggleIdentifiers.contains($0.toggleIdentifier) == true &&
                $0.allowsContentModifications &&
                $0.isSubscribed == false
        }.first ?? EKEventStore.shared.calendars(for: .event).filter { // mutable
            calendarToggleIdentifiers.contains($0.toggleIdentifier) == true && $0.allowsContentModifications
        }.first ?? EKEventStore.shared.calendars(for: .event).first // don't care
        viewController?.present(eventEditVC, animated: true)
    }
}

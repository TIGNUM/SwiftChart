//
//  PrepareTripsViewModel.swift
//  QOT
//
//  Created by karmic on 28/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import EventKit

final class PrepareEventsViewModel {

    private let events: [EKEvent]

    let preparationTitle: String

    init(preparationTitle: String, events: [EKEvent]) {
        self.preparationTitle = preparationTitle
        self.events = events
    }

    var eventCount: Int {
        return events.count
    }

    func event(index: Index) -> EKEvent {
        return events[index]
    }
}

//
//  PrepareEventSelectionWorker.swift
//  QOT
//
//  Created by karmic on 27.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class PrepareEventSelectionWorker {

    // MARK: - Properties

    private let services: Services
    private let question: Question

    private lazy var calendarEvents: [CalendarEvent] = {
        let start = Date()
        let finish = start.addingTimeInterval(TimeInterval(days: 30))
        let events = services.eventsService.calendarEvents(from: start, to: finish)
        return events
    }()

    // MARK: - Init

    init(services: Services, question: Question) {
        self.services = services
        self.question = question
    }

    var selectedAnswer: Answer? {
        return question.answers.first
    }

    var eventStore: EKEventStore {
        return services.eventsService.eventStore
    }

    var rowCount: Int {
        return calendarEvents.count
    }

    func event(at indexPath: IndexPath) -> CalendarEvent? {
        return calendarEvents[indexPath.row]
    }

    func dateString(for event: CalendarEvent?) -> String? {
        guard let date = event?.startDate else { return nil }
        if date.isToday == true {
            return String(format: "Today at %@", date.time)
        }
        if date.isTomorrow == true {
            return String(format: "Tomorrow at %@", date.time)
        }
        if date.isInCurrentWeek == true {
            return String(format: "%@ at %@", date.weekDayName, date.time)
        }
        return DateFormatter.mediumDate.string(from: date)
    }
}

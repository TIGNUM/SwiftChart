//
//  PrepareEventSelectionWorker.swift
//  QOT
//
//  Created by karmic on 27.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class PrepareEventSelectionWorker {

    // MARK: - Properties

    private let question: QDMQuestion
    private let events: [QDMUserCalendarEvent]

    // MARK: - Init

    init(question: QDMQuestion, events: [QDMUserCalendarEvent]) {
        self.question = question
        self.events = events
    }

    var selectedAnswer: QDMAnswer? {
        return question.answers.first
    }

    var rowCount: Int {
        return events.count
    }

    func event(at indexPath: IndexPath) -> QDMUserCalendarEvent {
        return events[indexPath.row]
    }

    func dateString(for event: QDMUserCalendarEvent?) -> String? {
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

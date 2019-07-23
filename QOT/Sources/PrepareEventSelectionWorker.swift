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
    private var model = [PrepareEvent]()

    // MARK: - Init
    init(question: QDMQuestion, events: [QDMUserCalendarEvent], preparations: [QDMUserPreparation]) {
        self.question = question
        createModel(events: events, preparations: preparations)
    }

    var selectedAnswer: QDMAnswer? {
        return question.answers.first
    }

    var rowCount: Int {
        return model.count
    }

    func event(at indexPath: IndexPath) -> PrepareEvent {
        return model[indexPath.row]
    }

    func dateString(for date: Date?) -> String? {
        guard let date = date else { return nil }
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

    func prepareDateString(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        return String(format: "Created %@", DateFormatter.mediumDate.string(from: date))
    }
}

private extension PrepareEventSelectionWorker {
    func createModel(events: [QDMUserCalendarEvent], preparations: [QDMUserPreparation]) {
        if events.isEmpty == false {
            events.forEach { (event) in
                model.append(PrepareEvent(title: event.title,
                                          dateString: dateString(for: event.startDate),
                                          date: event.startDate,
                                          userCalendarEvent: event,
                                          userPreparation: nil))
            }
        }
        if preparations.isEmpty == false {
            preparations.forEach { (preparation) in
                model.append(PrepareEvent(title: preparation.name,
                                          dateString: prepareDateString(preparation.createdAt),
                                          date: preparation.createdAt,
                                          userCalendarEvent: nil,
                                          userPreparation: preparation))
            }
        }
    }
}

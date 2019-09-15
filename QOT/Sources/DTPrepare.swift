//
//  DTPrepare.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct Prepare {
	struct QuestionKey {
        static let Intro = "prepare-key-intro"
        static let CalendarEventSelectionDaily = "prepare-key-calendar-event-selection-daily"
        static let CalendarEventSelectionCritical = "prepare-key-calendar-event-selection-critical"
        static let EventTypeSelectionDaily = "prepare-event-type-selection-daily"
        static let EventTypeSelectionCritical = "prepare-event-type-selection-critical"
        static let ShowTBV = "prepare_peak_prep_review_tbv"
        static let BenefitsInput = "prepare_peak_prep_benefits_input"
        static let BuildCritical = "prepare_peak_prep_build_plan"
        static let SelectExisting = "prepare_previous_preps_selection"
        static let Last = "prepare_key_last"
    }

    struct AnswerKey {
        static let OpenCheckList = "open_preparation_check_list_on_the_go"
        static let OpenCalendarEventSelectionDaily = "prepare-key-calendar-event-selection-daily"
        static let EventTypeSelectionDaily = "open_preparation_event_selection_daily"
        static let EventTypeSelectionCritical = "open_preparation_event_selection_critical"
        static let PeakPlanNew = "prepare_peak_prep_plan_new"
        static let PeakPlanTemplate = "prepare_peak_prep_plan_template"
    }

    static func isCalendarEventSelection(_ questionKey: String) -> Bool {
        return questionKey == QuestionKey.CalendarEventSelectionDaily
            || questionKey == QuestionKey.CalendarEventSelectionCritical
    }

    static func dateString(for date: Date?) -> String? {
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

    static func prepareDateString(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        return String(format: "Created %@", DateFormatter.mediumDate.string(from: date))
    }
}

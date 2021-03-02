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
        static let EventTypeSelectionDaily = "x-prepare-event-type-selection-daily"
        static let EventTypeSelectionCritical = "x-prepare-event-type-selection-critical"
        static let ShowTBV = "x_prepare_peak_prep_review_tbv"
        static let BenefitsInput = "prepare_peak_prep_benefits_input"
        static let BuildCritical = "x_prepare_peak_prep_build_plan"
        static let SelectExisting = "prepare_previous_preps_selection"
        static let Last = "prepare_key_last"
    }

    struct QuestionTargetId {
        static let IntentionPerceived = 100326
    }

    struct AnswerKey {
        static let OpenCheckList = "open_preparation_check_list_on_the_go"
        static let EventTypeSelectionDaily = "open_preparation_event_selection_daily"
        static let EventTypeSelectionCritical = "open_preparation_event_selection_critical"
        static let KindOfEventSelectionDaily = "x_prepare_event_type_selection_daily"
        static let KindOfEvenSelectionCritical = "x_prepare_event_type_selection_critical"
        static let PeakPlanNew = "x_prepare_peak_prep_plan_new"
        static let PeakPlanTemplate = "x_prepare_peak_prep_plan_template"
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

    static let AnswerFilter = "x_prepare_event_type_relationship_"

    enum Key: String {
        case perceived = "x_prepare_peak_prep_relationship_intentions_preceived"
        case know = "x_prepare_peak_prep_relationship_intentions_know"
        case feel = "x_prepare_peak_prep_relationship_intentions_feel"
        case benefits = "prepare_peak_prep_benefits_input"
        case benefitsTitle = "prepare_check_list_critical_benefits_title"
        case eventType = "x-prepare-event-type-selection-critical"

        var questionID: Int {
            switch self {
            case .perceived: return 100390
            case .know: return 100396
            case .feel: return 100397
            case .benefits: return 100332
            case .benefitsTitle: return .zero
            case .eventType: return 100339
            }
        }

        var tag: String {
            switch self {
            case .perceived: return "PERCEIVED"
            case .know: return "KNOW"
            case .feel: return "FEEL"
            case .benefits: return "BENEFITS"
            case .benefitsTitle,
                 .eventType: return ""
            }
        }
    }
}

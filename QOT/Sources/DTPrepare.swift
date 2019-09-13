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
    }

    struct AnswerKey {
        static let OpenCheckList = "open_preparation_check_list_on_the_go"
        static let OpenCalendarEventSelectionDaily = "prepare-key-calendar-event-selection-daily"
        static let EventTypeSelectionDaily = "open_preparation_event_selection_daily"
        static let EventTypeSelectionCritical = "open_preparation_event_selection_critical"
        static let PeakPlanNew = "prepare_peak_prep_plan_new"
        static let PeakPlanTemplate = "prepare_peak_prep_plan_template"
    }
}

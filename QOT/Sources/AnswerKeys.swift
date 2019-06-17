//
//  AnswerKeys.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 21.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

// MARK: - AnswerKey

enum AnswerKey {

    enum ToBeVision: String {
        case uploadImage = "tbv-answer-key-upload-image"
    }

    enum Prepare: String {
        case openCheckList = "open_preparation_check_list_on_the_go"
        case openCalendarEventSelectionDaily = "prepare-key-calendar-event-selection-daily"
        case eventTypeSelectionDaily = "prepare_event_type_selection_daily"
        case eventTypeSelectionCritical = "prepare_event_type_selection_critical"
    }

    enum Solve: String {
        case letsDoIt = "solve-lets-do-it"
        case openVisionPage = "open-vision-page"
    }
}

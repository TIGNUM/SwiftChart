//
//  PrepareCheckListModel.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

enum PrepareCheckListItem {
    case contentItem(itemFormat: ContentItemFormat?, title: String?)
    case eventItem(title: String, date: Date, type: String)
    case strategy(title: String, durationString: String, readMoreID: Int)
    case reminder(title: String, subbtitle: String, active: Bool)
    case intentionContentItem(
        itemFormat: ContentItemFormat?,
        title: String?,
        selectedAnswers: [DecisionTreeModel.SelectedAnswer],
        answerFilter: String?,
        questionID: Int)
    case intentionItem(selectedAnswer: DecisionTreeModel.SelectedAnswer, answerFilter: String)
    case benefitContentItem(itemFormat: ContentItemFormat?, title: String?, benefits: String?, questionID: Int)
    case benefitItem(benefits: String?)
}

enum PrepareCheckListTag: String {
    case perceived = "prepare_check_list_critical_preceived"
    case know = "prepare_check_list_critical_know"
    case feel = "prepare_check_list_critical_feel"
    case benefits = "prepare_check_list_critical_benefits"
    case benefitsTitle = "prepare_check_list_critical_benefits_title"
    case eventType = "prepare-event-type-selection-critical"

    var questionID: Int {
        switch self {
        case .perceived: return 100326
        case .know: return 100330
        case .feel: return 100331
        case .benefits: return 100332
        case .benefitsTitle: return 0
        case .eventType: return 100339
        }
    }

    static func questionID(for contentItem: ContentItem) -> Int {
        if contentItem.valueText?.contains("PERCEIVED") == true {
            return PrepareCheckListTag.perceived.questionID
        }
        if contentItem.valueText?.contains("FEEL") == true {
            return PrepareCheckListTag.feel.questionID
        }
        if contentItem.valueText?.contains("KNOW") == true {
            return PrepareCheckListTag.know.questionID
        }
        if contentItem.valueText?.contains("BENEFITS") == true {
            return PrepareCheckListTag.benefits.questionID
        }
        return 0
    }
}

enum PrepareCheckListType {
    case onTheGo
    case daily
    case peakPerformance

    enum Section: Int {
        case header = 0
        case listTitleEvents
        case events
        case listTitleIntentions
        case intentions
        case listTitleStrategies
        case strategies
        case listTitleReminders
        case reminders
    }

    var contentID: Int {
        switch self {
        case .onTheGo: return 101256
        case .daily: return 101258
        case .peakPerformance: return 101260
        }
    }
}

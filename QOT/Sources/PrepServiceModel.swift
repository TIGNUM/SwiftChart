//
//  PrepServiceModel.swift
//  QOT
//
//  Created by karmic on 15.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct PrepServiceModel {
    var level: QDMUserPreparation.Level
    var benefits: String?
    var answerFilter: String?
    var contentCollectionId: Int
    var relatedStrategyId: Int
    var strategyIds: [Int]
    var preceiveAnswerIds: [Int]
    var knowAnswerIds: [Int]
    var feelAnswerIds: [Int]
    var eventType: String
    var event: QDMUserCalendarEvent

    init(level: QDMUserPreparation.Level,
         benefits: String?,
         answerFilter: String?,
         contentCollectionId: Int,
         relatedStrategyId: Int,
         strategyIds: [Int],
         preceiveAnswerIds: [Int],
         knowAnswerIds: [Int],
         feelAnswerIds: [Int],
         eventType: String,
         event: QDMUserCalendarEvent) {
        self.level = level
        self.benefits = benefits
        self.answerFilter = answerFilter
        self.contentCollectionId = contentCollectionId
        self.relatedStrategyId = relatedStrategyId
        self.strategyIds = strategyIds
        self.preceiveAnswerIds = preceiveAnswerIds
        self.knowAnswerIds = knowAnswerIds
        self.feelAnswerIds = feelAnswerIds
        self.eventType = eventType
        self.event = event
    }

    init(preparation: QDMUserPreparation, event: QDMUserCalendarEvent?, eventType: String?) {
        self.level = preparation.type ?? .LEVEL_CRITICAL
        self.benefits = preparation.benefits
        self.answerFilter = preparation.answerFilter
        self.contentCollectionId = preparation.contentCollectionId ?? 0
        self.relatedStrategyId = preparation.relatedStrategyId ?? 0
        self.strategyIds = preparation.strategyIds
        self.preceiveAnswerIds = preparation.preceiveAnswerIds
        self.knowAnswerIds = preparation.knowAnswerIds
        self.feelAnswerIds = preparation.feelAnswerIds
        self.eventType = eventType ?? ""
        self.event = event ?? QDMUserCalendarEvent()
    }
}

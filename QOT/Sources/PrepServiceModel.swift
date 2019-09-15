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
    let level: QDMUserPreparation.Level
    let benefits: String?
    let answerFilter: String?
    let contentCollectionId: Int
    let relatedStrategyId: Int
    let strategyIds: [Int]
    let preceiveAnswerIds: [Int]
    let knowAnswerIds: [Int]
    let feelAnswerIds: [Int]
    let eventType: String
    let event: QDMUserCalendarEvent
}

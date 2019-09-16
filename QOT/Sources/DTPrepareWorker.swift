//
//  DTPrepareWorker.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTPrepareWorker: DTWorker {
    func getEvents(_ completion: @escaping ([QDMUserCalendarEvent], Bool) -> Void) {
        CalendarService.main.getCalendarEvents { (events, initiated, error) in
            if let error = error {
                log("Error getCalendarEvents: \(error.localizedDescription)", level: .error)
            }
            completion(events ?? [], initiated ?? false)
        }
    }

    func getPreparations(_ completion: @escaping ([QDMUserPreparation], Bool) -> Void) {
        UserService.main.getUserPreparations { (preparations, initiated, error) in
            if let error = error {
                log("Error getUserPreparations: \(error.localizedDescription)", level: .error)
            }
            completion(preparations ?? [], initiated)
        }
    }

    func createPreparationDaily(answerFilter: String,
                                relatedStategyId: Int,
                                eventType: String,
                                event: QDMUserCalendarEvent,
                                _ completion: @escaping (QDMUserPreparation?) -> Void) {
        UserService.main.createUserPreparation(level: QDMUserPreparation.Level.LEVEL_DAILY,
                                               benefits: nil,
                                               answerFilter: nil,
                                               contentCollectionId: QDMUserPreparation.Level.LEVEL_DAILY.contentID,
                                               relatedStrategyId: relatedStategyId,
                                               strategyIds: [],
                                               preceiveAnswerIds: [],
                                               knowAnswerIds: [],
                                               feelAnswerIds: [],
                                               eventType: eventType,
                                               event: event) { (preparation, error) in
                                                if let error = error {
                                                    log("Error createUserPreparation DAILY: \(error.localizedDescription)", level: .error)
                                                }
                                                completion(preparation)
        }
    }

    func createUserPreparation(level: QDMUserPreparation.Level,
                               benefits: String?,
                               answerFilter: String?,
                               contentCollectionId: Int,
                               relatedStrategyId: Int,
                               strategyIds: [Int],
                               preceiveAnswerIds: [Int],
                               knowAnswerIds: [Int],
                               feelAnswerIds: [Int],
                               eventType: String,
                               event: QDMUserCalendarEvent,
                               _ completion: @escaping (QDMUserPreparation?) -> Void) {
        UserService.main.createUserPreparation(level: level,
                                               benefits: benefits,
                                               answerFilter: answerFilter,
                                               contentCollectionId: contentCollectionId,
                                               relatedStrategyId: relatedStrategyId,
                                               strategyIds: strategyIds,
                                               preceiveAnswerIds: preceiveAnswerIds,
                                               knowAnswerIds: knowAnswerIds,
                                               feelAnswerIds: feelAnswerIds,
                                               eventType: eventType,
                                               event: event) { (preparation, error) in
                                                if let error = error {
                                                    log("Error createUserPreparation: \(error.localizedDescription)", level: .error)
                                                }
                                                completion(preparation)
        }
    }

    func getRelatedStrategies(_ strategyId: Int, _ completion: @escaping ([Int]) -> Void) {
        ContentService.main.getContentCollectionById(strategyId) { (contentCollection) in
            completion(contentCollection?.relatedContentIDsPrepareDefault ?? [])
        }
    }
}

//
//  AbstractPrepareWorker.swift
//  QOT
//
//  Created by karmic on 01.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class PreparationManager {

    private let userService: qot_dal.UserService?
    static var main = PreparationManager()

    private init() {
        self.userService = qot_dal.UserService.main
    }
}

extension PreparationManager {
    func create(level: QDMUserPreparation.Level,
                benefits: String? = nil,
                answerFilter: String? = nil,
                contentCollectionId: Int,
                relatedStrategyId: Int,
                strategyIds: [Int] = [],
                eventType: String,
                event: QDMUserCalendarEvent,
                completion: @escaping (QDMUserPreparation?) -> Void) {
        userService?.createUserPreparation(level: level,
                                           benefits: benefits,
                                           answerFilter: answerFilter,
                                           contentCollectionId: contentCollectionId,
                                           relatedStrategyId: relatedStrategyId,
                                           strategyIds: [],
                                           preceiveAnswerIds: [],
                                           knowAnswerIds: [],
                                           feelAnswerIds: [],
                                           eventType: eventType,
                                           event: event) { (preparation, error) in
                                            if let error = error {
                                                log("Error while trying to create preparation: \(error.localizedDescription)",
                                                    level: QDLogger.Level.debug)
                                            }
                                            completion(preparation)
        }
    }

    func update(_ preparation: QDMUserPreparation?, _ completion: @escaping (QDMUserPreparation?) -> Void) {
        if let preparation = preparation {
            userService?.updateUserPreparation(preparation) { (preparation, error) in
                if let error = error {
                    log("Error while trying to update preparation: \(error.localizedDescription)", level: QDLogger.Level.debug)
                }
                completion(preparation)
            }
        } else {
            completion(nil)
        }
    }

    func delete(preparation: QDMUserPreparation, completion: @escaping () -> Void) {
        userService?.deleteUserPreparation(preparation) { (error) in
            if let error = error {
                log("Error while trying to delete preparation: \(error.localizedDescription)", level: QDLogger.Level.debug)
            }
            completion()
        }
    }

    func getAll(_ completion: @escaping (_ preparations: [QDMUserPreparation]?) -> Void) {
        userService?.getUserPreparations { (preparations, initialized, error) in
            if let error = error {
                log("Error while trying to get preparations: \(error.localizedDescription)", level: QDLogger.Level.debug)
            }
            completion(preparations)
        }
    }

    func get(for qotId: String, _ completion: @escaping (_ preparation: QDMUserPreparation?) -> Void) {
        userService?.getUserPreparations { (preparations, initialized, error) in
            if let error = error {
                log("Error while trying to get preparations: \(error.localizedDescription)", level: QDLogger.Level.debug)
            }
            let preparation = preparations?.filter { $0.qotId == qotId }.first
            completion(preparation)
        }
    }
}

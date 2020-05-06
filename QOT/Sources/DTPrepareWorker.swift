//
//  DTPrepareWorker.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

// MARK: - UserPreparations
final class DTPrepareWorker: DTWorker {
    func getPreparations(_ completion: @escaping ([QDMUserPreparation], Bool) -> Void) {
        UserService.main.getUserPreparations { (preparations, initiated, error) in
            if let error = error {
                log("Error getUserPreparations: \(error.localizedDescription)", level: .error)
            }
            completion(preparations ?? [], initiated)
        }
    }

    func createUserPreparation(from model: CreateUserPreparationModel,
                               _ completion: @escaping (QDMUserPreparation?) -> Void) {
        UserService.main.createUserPreparation(from: model) { (preparation, error) in
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

    func getRelatedStrategyItems(_ strategyId: Int, _ completion: @escaping ([Int]) -> Void) {
        ContentService.main.getContentCollectionById(strategyId) { (contentCollection) in
            completion(contentCollection?.relatedContentItemIDs ?? [])
        }
    }
}

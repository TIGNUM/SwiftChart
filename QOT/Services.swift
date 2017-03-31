//
//  Services.swift
//  QOT
//
//  Created by Sam Wyndham on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

struct Services {
    let databaseManager: DatabaseManager // FIXME: Delete once no longer needed
    let learnContent: LearnContentService

    static func make(completion: @escaping (Result<Services, NSError>) -> Void) {
        DispatchQueue.global().async {
            // Do expensive things here such as migrations.

            // FIXME: Remove
            do {
                setupRealmWithMockData(realm: try Realm())
            } catch let error {
                fatalError("Cannot create mock data: \(error)")
            }

            DispatchQueue.main.async {
                do {
                    let manager = try DatabaseManager()
                    let realmProvider = RealmProvider()
                    let learnContent = LearnContentService(mainRealm: manager.mainRealm, realmProvider: realmProvider)
                    let services = Services(databaseManager: manager, learnContent: learnContent)

                    completion(.success(services))
                } catch let error as NSError {
                    completion(.failure(error))
                }
            }
        }
    }
}

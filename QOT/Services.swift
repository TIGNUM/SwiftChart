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
                    let realmProvider = RealmProvider()
                    let mainRealm = try realmProvider.realm()
                    let learnContent = LearnContentService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let services = Services(learnContent: learnContent)

                    completion(.success(services))
                } catch let error as NSError {
                    completion(.failure(error))
                }
            }
        }
    }
}

//
//  DatabaseManager.swift
//  QOT
//
//  Created by Sam Wyndham on 10/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

/// Sets up and provides access to `Realm`s.
class DatabaseManager {
    /// The main `Realm`. It can be accessed on the main thread.
    let mainRealm: Realm
    
    private init() throws {
        precondition(Thread.isMainThread, "Must be initialized on main thread")
        self.mainRealm = try Realm()
    }
    
    static func make(completion: @escaping (Result<DatabaseManager, NSError>) -> Void) {
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
                    completion(.success(manager))
                } catch let error as NSError {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func backgroundRealm() throws -> Realm {
        return try Realm()
    }
}

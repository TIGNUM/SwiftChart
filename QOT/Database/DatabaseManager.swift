//
//  DatabaseManager.swift
//  QOT
//
//  Created by Sam Wyndham on 10/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

/// Sets up and provides access to `Realm`s.
class DatabaseManager {
    /// The main `Realm`. It can be accessed on the main thread.
    let mainRealm: Realm
    
    /// Creates an instance of `self`.
    ///
    /// - throws: An `NSError` if the main Realm could not be initialized.
    init() throws {
        precondition(Thread.isMainThread, "Must be initialized on main thread")
        self.mainRealm = try Realm()
        
        // FIXME: Remove
        setupRealmWithMockData(realm: self.mainRealm)
    }
}

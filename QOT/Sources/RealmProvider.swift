//
//  RealmProvider.swift
//  QOT
//
//  Created by Sam Wyndham on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmProvider {
    func realm() throws -> Realm {
        return try Realm(configuration: RealmProvider.config)
    }

    static var config: Realm.Configuration = {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsURL.appendingPathComponent("QOT.realm")
        
        return Realm.Configuration(fileURL:url,
                                   encryptionKey: databaseEncryptionKey,
                                   deleteRealmIfMigrationNeeded: true)
    }()
    
    static var databaseEncryptionKey: Data? {
        #if DEBUG
            // @warning we can't use the realm browser for an encrypted db at the same time as running the app, so we dont use a encryption key during debug mode
            return nil
        #else
            let service = DatabaseKeyService()
            var encryptionKey = service.keyData
            if encryptionKey == nil {
                do {
                    try service.generateNewKey()
                    encryptionKey = service.keyData
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
            return encryptionKey
        #endif
    }
}

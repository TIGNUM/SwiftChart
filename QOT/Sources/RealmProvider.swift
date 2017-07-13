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

    private static var config: Realm.Configuration = {
        // FIXME: EncryptionKey
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsURL.appendingPathComponent("QOT.realm")
        return Realm.Configuration(fileURL:url,
                                   encryptionKey: nil,
                                   deleteRealmIfMigrationNeeded: true)
    }()
}

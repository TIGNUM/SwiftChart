//
//  DatabaseManager.swift
//  QOT
//
//  Created by Lee Arromba on 10/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    enum Name: String {
        case v1 = "default-v1"
    }
    
    private let config: Realm.Configuration
    
    var isDatabaseCreated: Bool {
        guard let currentDatabaseFilePath = config.fileURL?.absoluteString.removeFilePrefix else {
            return false
        }
        return FileManager.default.fileExists(atPath: currentDatabaseFilePath)
    }
    
    init(config: Realm.Configuration) {
        self.config = config
    }
    
    func copyDefault(withName name: Name) throws {
        guard let realmURL = Realm.Configuration.defaultConfiguration.fileURL else {
            throw SimpleError(localizedDescription: "couldn't load Realm.Configuration.defaultConfiguration.fileURL")
        }
        guard let defaultURL = Bundle.main.url(forResource: name.rawValue, withExtension: "realm") else {
            throw SimpleError(localizedDescription: "couldn't find database with name \(name.rawValue)")
        }
        try FileManager.default.copyItem(at: defaultURL, to: realmURL)
        log("copied \(defaultURL) to \(realmURL)")
    }
}

//
//  DatabaseManager.swift
//  QOT
//
//  Created by Lee Arromba on 10/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Security

class DatabaseManager {
    enum Name: String {
        case v1 = "default-v1"

        var `extension`: String {
            return "realm"
        }
        var directory: String {
            return "Database"
        }
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
        guard let url = config.fileURL else {
            throw SimpleError(localizedDescription: "couldn't load config.fileURL")
        }
        let database = try loadDatabase(name)
        let service = DatabaseKeyService()

        #if DEBUG
            // @warning we can't use the realm browser for an encrypted db at the same time as running the app, so we dont use a encryption key during debug mode
            let encryptionKey: Data? = nil
        #else
            let encryptionKey = service.keyData
        #endif

        try database.writeCopy(toFile: url, encryptionKey: encryptionKey)
        log("copied bundled database \(name.rawValue) to \(url)")
    }
    
    func loadDatabase(_ name: Name) throws -> Realm {
        guard let databaseURL = fileURLForName(name) else {
            throw SimpleError(localizedDescription: "couldn't find database with name \(name.rawValue)")
        }
        let config = Realm.Configuration(fileURL: databaseURL, encryptionKey: nil, readOnly: true, deleteRealmIfMigrationNeeded: false)
        let database = try Realm(configuration: config)
        return database
    }
    
    func fileURLForName(_ name: Name) -> URL? {
        return Bundle.main.url(forResource: name.rawValue, withExtension: name.extension, subdirectory: name.directory)
    }
    
    func populateAllObjects(fromDatabase: Realm, toDatabase: Realm) throws {
        let classNames = classNamesFromDatabase(fromDatabase)
        try classNames.forEach { (className: String) in
            let objects = fromDatabase.dynamicObjects(className)
            try toDatabase.write {
                objects.forEach { (object: DynamicObject) in
                    toDatabase.dynamicCreate(className, value: object, update: (DynamicObject.primaryKey() != nil))
                }
            }
        }
    }
    
    func classNamesFromDatabase(_ database: Realm) -> [String] {
        return database.schema.objectSchema.map({ $0.className })
    }
    
    func classNamesWithEntitiesFromDatabase(_ database: Realm) -> [String] {
        return classNamesFromDatabase(database).filter({ database.dynamicObjects($0).count > 0 })
    }
    
    func deleteAllObjectsWithClassNames(_ classNames: [String], fromDatabase database: Realm) throws {
        try classNames.forEach { (className: String) in
            let objects = database.dynamicObjects(className)
            try database.write {
                database.delete(objects)
            }
        }
    }
    
    func deleteAllObjectsFromDatabase(_ database: Realm) throws {
        try database.write {
            database.deleteAll()
        }
    }
}

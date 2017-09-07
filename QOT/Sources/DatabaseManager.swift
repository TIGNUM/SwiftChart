//
//  DatabaseManager.swift
//  QOT
//
//  Created by Lee Arromba on 10/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import Security

final class DatabaseManager {

    enum State {
        case starting
        case ready
        case failed(Error)
    }

    private var _state: State = .starting
    private var _onSetupCompleteClosures: [(Error?) -> Void] = []
    private var _configuration: Realm.Configuration?

    private let lockQueue = DispatchQueue(label: "com.tignum.qot.databaseManager.lock", qos: .default)
    private let setupQueue = DispatchQueue(label: "com.tignum.qot.databaseManager.setup", qos: .userInitiated)
    static let shared = DatabaseManager()

    private(set) var state: State {
        get {
            var state: State!
            lockQueue.sync {
                state = _state
            }
            return state
        } set {
            lockQueue.sync {
                _state = newValue
            }
        }
    }

    static var databaseURL: URL {
        return URL.mainRealm
    }

    func onSetupComplete(_ closure: @escaping (Error?) -> Void) {
        DispatchQueue.main.async { [unowned self] in
            switch self.state {
            case .starting:
                self._onSetupCompleteClosures.append(closure)
            case .ready:
                closure(nil)
            case .failed(let error):
                closure(error)
            }
        }
    }

    func configuration() throws -> Realm.Configuration {
        var config: Realm.Configuration?
        setupQueue.sync {
            config = _configuration
        }
        if let config = config {
            return config
        }
        throw SimpleError(localizedDescription: "DatabaseManager failed to complete setup")
    }

    // MARK: Setup

    private init() {
        setupQueue.async { [unowned self] in
            do {
                try self.setup()
                self.state = .ready
                self.setupComplete(error: nil)
            } catch {
                self.state = .failed(error)
                self.setupComplete(error: error)
            }
        }
    }

    private func setup() throws {
        let encryptionKey = try DatabaseKeyService().encryptionKey()
        let mainConfig = Realm.Configuration.main(encryptionKey: encryptionKey)

        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: mainConfig.fileURL!.path) {
            do {
                _ = try Realm(configuration: mainConfig)
                _configuration = mainConfig
                // Realm exists and can be opened so return
                return
            } catch let error as RLMError {
                switch error.code {
                case .schemaMismatch:
                    try fileManager.removeItem(at: URL.mainRealmDirectory)
                default:
                    throw error
                }
            }
        }

        try fileManager.createDirectory(at: URL.mainRealmDirectory, withIntermediateDirectories: true)
        do {
            let seedRealm = try Realm(configuration: .seed())
            try seedRealm.writeCopy(toFile: URL.mainRealm, encryptionKey: encryptionKey)
            log("copied seed database to \(URL.mainRealm)")
        } catch {
            // Just log the errors. The app will still work
            log("failed to copy seed database to \(URL.mainRealm), error: \(error)")
        }

        _ = try Realm(configuration: mainConfig)
        _configuration = mainConfig
    }

    private func setupComplete(error: Error?) {
        DispatchQueue.main.async { [unowned self] in
            let closures = self._onSetupCompleteClosures
            self._onSetupCompleteClosures = []
            closures.forEach { $0(error) }
        }
    }

    // MARK: Reseting Database

    func resetDatabase(syncRecordService: SyncRecordService) throws {
        let mainRealm = try Realm(configuration: configuration())
        let seedRealm = try Realm(configuration: .seed())

        let classNamesToKeep = Set(classNamesWithEntitiesFromDatabase(seedRealm))
        var classNamesToDelete = Set(classNamesFromDatabase(mainRealm))
        classNamesToDelete.subtract(classNamesToKeep)
        let classNamesToDeleteArray = Array(classNamesToDelete)
        try syncRecordService.deleteSyncRecordsForClassNames(classNamesToDeleteArray)
        try deleteAllObjectsWithClassNames(classNamesToDeleteArray, fromDatabase: mainRealm)
    }
    
    private func classNamesFromDatabase(_ database: Realm) -> [String] {
        return database.schema.objectSchema.map({ $0.className })
    }
    
    private func classNamesWithEntitiesFromDatabase(_ database: Realm) -> [String] {
        return classNamesFromDatabase(database).filter({ database.dynamicObjects($0).count > 0 })
    }
    
    private func deleteAllObjectsWithClassNames(_ classNames: [String], fromDatabase database: Realm) throws {
        try classNames.forEach { (className: String) in
            let objects = database.dynamicObjects(className)
            try database.write {
                database.delete(objects)
            }
        }
    }
}

// MARK: Helpers

private extension URL {

    static var mainRealmDirectory: URL {
        return URL.documentsDirectory.appendingPathComponent("database")
    }

    static var mainRealm: URL {
        return mainRealmDirectory.appendingPathComponent("QOT.realm")
    }

    static var seedRealm: URL {
        return Bundle.main.url(forResource: "default-v1", withExtension: "realm", subdirectory: "Database")!
    }
}

private extension Realm.Configuration {

    static func main(encryptionKey: Data?) -> Realm.Configuration {
        return Realm.Configuration(fileURL: URL.mainRealm, encryptionKey: encryptionKey)
    }

    static func seed() -> Realm.Configuration {
        return Realm.Configuration(fileURL: URL.seedRealm, readOnly: true)
    }
}

private extension DatabaseKeyService {

    func encryptionKey() throws -> Data? {
        #if DEBUG
            return nil
        #else
            return try keyData ?? generateNewKey()
        #endif
    }
}

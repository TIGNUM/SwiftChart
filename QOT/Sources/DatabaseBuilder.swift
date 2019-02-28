//
//  DatabaseBuilder.swift
//  QOT
//
//  Created by Lee Arromba on 11/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

#if BUILD_DATABASE

import Foundation
import RealmSwift

class BuilderRealmProvider: RealmProvider {

    override func realm() throws -> Realm {
        let url = URL.documentDirectory.appendingPathComponent("temp.realm")
        let config = Realm.Configuration(fileURL: url, encryptionKey: nil)
        return try Realm(configuration: config)
    }
}

class DatabaseBuilder {
    private let networkManager: NetworkManager
    private let syncRecordService: SyncRecordService
    private let realmProvider: RealmProvider
    private let deviceID: String
    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    private var operations: [Operation]?

    init(networkManager: NetworkManager, syncRecordService: SyncRecordService, realmProvider: RealmProvider, deviceID: String) {
        self.networkManager = networkManager
        self.syncRecordService = syncRecordService
        self.realmProvider = realmProvider
        self.deviceID = deviceID
    }

    func setContentOperations(_ operations: [ConcurrentOperation]) {
        self.operations = operations
    }

    func setCompletion(_ completion: @escaping () -> Void) {
        operations?.append(BlockOperation(block: completion))
    }

    func build() {
        guard let operations = operations else { return }
        networkManager.performAuthenticationRequest(username: "m.karbe@tignum.com", password: "Tignum@1234") { (error) in
            if let error = error {
                log(error)
            } else {
                self.operationQueue.addOperations(operations, waitUntilFinished: false)
            }
        }
    }

    func downSyncOperation<P>(for: P.Type, context: SyncContext)
        -> SyncOperation where P: DownSyncable, P: SyncableObject, P.Data: DownSyncIntermediary {
        let downSyncTask = DownSyncTask<P>(networkManager: networkManager,
                                           realmProvider: realmProvider,
                                           syncRecordService: syncRecordService)
            return SyncOperation(upSyncTask: nil, downSyncTask: downSyncTask, syncContext: context, debugIdentifier: String(describing: self))
    }

    func updateRelationsOperation(context: SyncContext) -> UpdateRelationsOperation {
        return UpdateRelationsOperation(context: context, realmProvider: realmProvider)
    }

    // @see https://realm.io/docs/swift/latest/#bundling-a-realm-with-an-app
    func copyWithName(_ name: String) throws -> URL? {
        guard var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw SimpleError(localizedDescription: "can't find documents directory")
        }
        path.appendPathComponent("\(name)")
        let realm = try realmProvider.realm()
        try realm.writeCopy(toFile: path, encryptionKey: nil)
        log("copied database to \(path)")
        return path
    }
}

#endif

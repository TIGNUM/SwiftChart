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
        guard let operations = operations else {
            return
        }
        let request = AuthenticationRequest(username: "qotapptester@tignum.com", password: "1111", deviceID: deviceID)
        self.networkManager.request(request, parser: AuthenticationTokenParser.parse) { [weak self] (result) in
            switch result {
            case .success:
                self?.operationQueue.addOperations(operations, waitUntilFinished: false)
            case .failure(let error):
                log(error)
            }
        }
    }
    
    func downSyncOperation<P>(for: P.Type, context: SyncContext) -> DownSyncOperation<P> where P: DownSyncable, P: SyncableObject {
        return DownSyncOperation<P>(context: context,
                                    networkManager: networkManager,
                                    syncRecordService: syncRecordService,
                                    realmProvider: realmProvider,
                                    downSyncImporter: DownSyncImporter())
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

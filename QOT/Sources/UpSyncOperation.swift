//
//  UpSyncOperation.swift
//  QOT
//
//  Created by Sam Wyndham on 24.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class UpSyncOperation<T>: ConcurrentOperation where T: Object, T: UpSyncable {

    private let networkManager: NetworkManager
    private let realmProvider: RealmProvider
    private let context: SyncContext
    private let isFinalOperation: Bool
    private let jsonEncoder: (T) -> JSON?

    init(networkManager: NetworkManager,
         realmProvider: RealmProvider,
         syncContext: SyncContext,
         isFinalOperation: Bool,
         jsonEncoder: @escaping (T) -> JSON?) {
        self.networkManager = networkManager
        self.realmProvider = realmProvider
        self.context = syncContext
        self.jsonEncoder = jsonEncoder
        self.isFinalOperation = isFinalOperation
    }

    override func execute() {
        guard context.state != .finished else {
            finish()
            return
        }

        fetchSyncToken()
    }

    // MARK: Steps

    private func fetchSyncToken() {
        let request = StartSyncRequest(from: 0) // Any from value is fine here as it is ignored by the server
        networkManager.request(request, parser: StartSyncResult.parse) { [weak self] (result) in
            switch result {
            case .success(let startSyncRestult):
                self?.fetchDirtyObjects(syncToken: startSyncRestult.syncToken)
            case .failure(let error):
                self?.finish(error: .upSyncStartSyncFailed(error: error))
            }
        }
    }

    private func fetchDirtyObjects(syncToken: String) {
        do {
            let dirty = try DirtyObjects<T>(realm: realmProvider, encoder: jsonEncoder)
            if dirty.count == 0 {
                finish(error: nil)
            } else {
                sendDirty(objects: dirty, syncToken: syncToken)
            }
        } catch let error {
            finish(error: .upSyncFetchDirtyFailed(error: error))
        }
    }

    private func sendDirty(objects: DirtyObjects<T>, syncToken: String) {
        let request = UpSyncRequest(endpoint: T.endpoint, body: objects.body, syncToken: syncToken)
        networkManager.request(request, parser: UpSyncResultParser.parse) { [weak self] (result) in
            switch result {
            case .success(let upSyncResult):
                self?.updateDirty(objects: objects, result: upSyncResult)
            case .failure(let error):
                self?.finish(error: .upSyncSendDirtyFailed(error: error))
            }
        }
    }

    private func updateDirty(objects: DirtyObjects<T>, result: UpSyncResult) {
        do {
            let remoteIDs = result.remoteIDs
            let realm = try realmProvider.realm()
            try realm.write {
                try objects.completions.forEach { try $0(remoteIDs, realm)  }
            }
            fetchDirtyObjects(syncToken: result.nextSyncToken)
        } catch let error {
            finish(error: .upSyncUpdateDirtyFailed(error: error))
        }
    }

    private func finish(error: SyncError?) {
        if let error = error {
            context.add(error: error)
        }

        if isFinalOperation {
            context.finish()
        }

        finish()
    }
}

private struct DirtyObjects<T> where T: Object, T: UpSyncable {

    let body: Data
    let completions: [(LocalIDToRemoteIDMap, Realm) throws -> Void]

    var count: Int {
        return completions.count
    }

    init(realm: RealmProvider, encoder: @escaping (T) -> JSON?, max: Int = 50) throws {
        let realm = try realm.realm()
        let objectsWithJSON = (realm.objects(predicate: T.dirtyPredicate) as Results<T>).prefix(max).flatMap { (object) -> (T, JSON)? in
            if let json = encoder(object), object.syncStatus != .clean {
                return (object, json)
            } else {
                return nil
            }
        }

        self.body = try objectsWithJSON.map { $0.1 }.toJSON().serialize()
        self.completions = objectsWithJSON.map { $0.0.completeUpSync() }
    }
}

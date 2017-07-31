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

    init(networkManager: NetworkManager,
         realmProvider: RealmProvider,
         syncContext: SyncContext,
         isFinalOperation: Bool) {
        self.networkManager = networkManager
        self.realmProvider = realmProvider
        self.context = syncContext
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
            if let dirty = try T.upSyncData(realm: realmProvider) {
                sendDirty(data: dirty, syncToken: syncToken)
            } else {
                finish(error: nil)
            }
        } catch let error {
            finish(error: .upSyncFetchDirtyFailed(error: error))
        }
    }

    private func sendDirty(data: UpSyncData, syncToken: String) {
        let request = UpSyncRequest(endpoint: T.endpoint, body: data.body, syncToken: syncToken)
        networkManager.request(request, parser: UpSyncResultParser.parse) { [weak self] (result) in
            switch result {
            case .success(let upSyncResult):
                self?.updateDirty(data: data, result: upSyncResult)
            case .failure(let error):
                self?.finish(error: .upSyncSendDirtyFailed(error: error))
            }
        }
    }

    private func updateDirty(data: UpSyncData, result: UpSyncResult) {
        do {
            let realm = try realmProvider.realm()
            try realm.write {
                try data.completion(result.remoteIDs, realm)
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

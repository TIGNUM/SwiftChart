//
//  SyncManager.swift
//  QOT
//
//  Created by Sam Wyndham on 29.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy
import RealmSwift

final class SyncManager {

    let networkManager: NetworkManger
    let syncRecordService: SyncRecordService
    let realmProvider: RealmProvider
    let operationQueue = OperationQueue()

    init(networkManager: NetworkManger, syncRecordService: SyncRecordService, realmProvider: RealmProvider) {
        self.networkManager = networkManager
        self.syncRecordService = syncRecordService
        self.realmProvider = realmProvider
    }

    func sync() {
        let context = SyncContext(queue: operationQueue)
        let startSyncOperation = StartSyncNetworkOperation(context: context, networkManager: networkManager)
        operationQueue.addOperation(startSyncOperation)

        // FIXME: To be completed.
    }
}

private extension SyncManager {

    func downSyncOperations<T, U>(desciption: SyncDescription<T, U>, context: SyncContext) throws -> [Operation]  where T: JSONDecodable, U: DownSyncable, U: Object {
        let syncType = desciption.syncType
        let networkOp = DownSyncNetworkOperation<T>(context: context, networkManager: networkManager, syncType: syncType)
        let databaseOp = DownSyncDatabaseOperation<U>(context: context, syncType: syncType, storeProvider: realmProvider)
        let recordSyncOp = RecordSyncOperation<U>(context: context, service: syncRecordService, type: syncType)

        return [networkOp, databaseOp, recordSyncOp]
    }

    // MARK: Syncs

    func contentCategoryDownOperations(context: SyncContext) throws -> [Operation] {
        return try downSyncOperations(desciption: ContentCategoryDown, context: context)
    }
}

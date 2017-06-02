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
        operationQueue.maxConcurrentOperationCount = 1
        let context = SyncContext(queue: operationQueue)
        let operations = downSyncOperations(desciption: ContentCategoryDown, context: context)
        operationQueue.addOperations(operations, waitUntilFinished: false)

        // FIXME: To be completed.
    }
}

private extension SyncManager {

    func downSyncOperations<T, U>(desciption: SyncDescription<T, U>, context: SyncContext) -> [Operation]  where T: JSONDecodable, U: DownSyncable, U: Object {
        let syncType = desciption.syncType
        let startSyncOp = StartSyncNetworkOperation(context: context, networkManager: networkManager)
        let networkOp = DownSyncNetworkOperation<T>(context: context, networkManager: networkManager, syncType: syncType)
        let databaseOp = DownSyncDatabaseOperation<U>(context: context, syncType: syncType, storeProvider: realmProvider)
        let recordSyncOp = RecordSyncOperation<U>(context: context, service: syncRecordService, type: syncType)

        return [startSyncOp, networkOp, databaseOp, recordSyncOp]
    }

    // MARK: Syncs

    func contentCategoryDownOperations(context: SyncContext) -> [Operation] {
        return downSyncOperations(desciption: ContentCategoryDown, context: context)
    }
}

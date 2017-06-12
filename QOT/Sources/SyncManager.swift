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

    let networkManager: NetworkManager
    let syncRecordService: SyncRecordService
    let realmProvider: RealmProvider
    let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    init(networkManager: NetworkManager, syncRecordService: SyncRecordService, realmProvider: RealmProvider) {
        self.networkManager = networkManager
        self.syncRecordService = syncRecordService
        self.realmProvider = realmProvider
    }

    func syncAll() {
        let context = SyncContext(queue: operationQueue)
        let operations: [Operation] = [
            downSyncOperation(for: ContentCategoryDown, context: context),
            downSyncOperation(for: ContentCollectionDown, context: context),
            downSyncOperation(for: ContentItemDown, context: context)
        ]

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    private func downSyncOperation<I, P>(for description: SyncDescription<I, P>, context: SyncContext) -> DownSyncOperation<I, P> where I: JSONDecodable, P: DownSyncable, P: Object, P.Data == I {
        return DownSyncOperation(context: context,
                                 networkManager: networkManager,
                                 description: description,
                                 syncRecordService: syncRecordService,
                                 realmProvider: realmProvider,
                                 downSyncImporter: DownSyncImporter())
    }
}


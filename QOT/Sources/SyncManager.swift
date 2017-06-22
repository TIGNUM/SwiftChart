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
        let context = SyncContext(queue: operationQueue) { (state) in
            switch state {
            case .errored(let error):
                print("SYNC FAILED: \(error)")
            case .finished:
                print("SYNC SUCCEEDED")
            default:
                break
            }
        }

        let operations: [Operation] = [
//            downSyncOperation(for: UserDown, context: context), API is currently returning non parsable data.
            downSyncOperation(for: PageDown, context: context),
            downSyncOperation(for: ContentCategoryDown, context: context),
            downSyncOperation(for: ContentCollectionDown, context: context),
            downSyncOperation(for: ContentItemDown, context: context, isFinalOperation: true)
        ]

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    func syncCalendarEvents() {
        let context = SyncContext(queue: operationQueue) { (state) in
            switch state {
            case .errored(let error):
                print("SYNC FAILED: \(error)")
            case .finished:
                print("SYNC SUCCEEDED")
            default:
                break
            }
        }

        let operations: [Operation] = [
            UpSyncCalendarEventsOperation(networkManager: networkManager, realmProvider: realmProvider, syncContext: context, isFinalOperation: true)
        ]

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    func syncAllMockJSONs() {
        let context = SyncContext(queue: operationQueue) { (state) in
            switch state {
            case .errored(let error):
                print("CONTENT SYNC FAILED: \(error)")
            default:
                break
            }
        }

        let operations: [Operation] = [
            downSyncOperation(for: UserDown, context: context),
            downSyncOperation(for: ContentCategoryDown, context: context),
            downSyncOperation(for: ContentCollectionDown, context: context),
            downSyncOperation(for: ContentItemDown, context: context),
            downSyncOperation(for: PageDown, context: context)
        ]

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    private func downSyncOperation<I, P>(for description: SyncDescription<I, P>, context: SyncContext, isFinalOperation: Bool = false) -> DownSyncOperation<I, P> where I: JSONDecodable, P: DownSyncable, P: Object, P.Data == I {
        return DownSyncOperation(context: context,
                                 networkManager: networkManager,
                                 description: description,
                                 syncRecordService: syncRecordService,
                                 realmProvider: realmProvider,
                                 downSyncImporter: DownSyncImporter(),
                                 isFinalOperation: isFinalOperation)
    }
}

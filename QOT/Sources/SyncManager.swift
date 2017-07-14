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
    var isSyncRecordsValid: Bool {
        do {
            for value in SyncType.allValues {
                guard try syncRecordService.lastSync(type: value) > 0 else {
                    return false
                }
            }
        } catch {
            return false
        }
        return true
    }

    init(networkManager: NetworkManager, syncRecordService: SyncRecordService, realmProvider: RealmProvider) {
        self.networkManager = networkManager
        self.syncRecordService = syncRecordService
        self.realmProvider = realmProvider
    }

    func clearAll() throws {
        operationQueue.cancelAllOperations()
        let realm = try realmProvider.realm()
        try realm.write {
            realm.deleteAll()
        }
    }
    
    func syncAll() {
        NotificationHandler.postNotification(withName: .syncStartedNotification)
        
        let context = SyncContext(queue: operationQueue) { (state, errors) in
            switch state {
            case .finished:
                NotificationHandler.postNotification(withName: .syncFinishedNotification)
                print("SYNC ALL FINISHED with \(errors.count) errors")
                errors.forEach({ (error: SyncError) in
                    print(error)
                })
            default:
                break
            }
        }

        let operations: [Operation] = [
            downSyncOperation(for: SystemSettingDown, context: context),
            downSyncOperation(for: UserSettingDown, context: context),
            downSyncOperation(for: UserDown, context: context),
            downSyncOperation(for: QuestionDown, context: context),
            downSyncOperation(for: PageDown, context: context),
            downSyncOperation(for: UserChoiceDown, context: context),
            downSyncOperation(for: ContentCategoryDown, context: context),
            downSyncOperation(for: ContentCollectionDown, context: context),
            downSyncOperation(for: DataPointDown, context: context),
            downSyncOperation(for: ContentItemDown, context: context),
            UpdateRelationsOperation(context: context, realmProvider: realmProvider, isFinalOperation: true)
        ]

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    func syncCalendarEvents() {
        let context = SyncContext(queue: operationQueue) { (state, errors) in
            switch state {
            case .finished:
                print("CALENDAR EVENTS SYNC FINISHED with \(errors.count) errors")
                errors.forEach({ (error: SyncError) in
                    print(error)
                })
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
        let context = SyncContext(queue: operationQueue) { (state, errors) in
            switch state {
            case .finished:
                print("SYNC ALL MOCK JSON FINISHED with \(errors.count) errors")
                errors.forEach({ (error: SyncError) in
                    print(error)
                })
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

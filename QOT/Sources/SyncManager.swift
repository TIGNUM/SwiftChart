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
import EventKit

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
            for value in downSyncClasses {
                guard try syncRecordService.lastSync(className: String(describing: value.self)) > 0 else {
                    return false
                }
            }
        } catch {
            return false
        }
        return true
    }

    var downSyncClasses: [AnyClass] {
        return [
            ContentCategory.self,
            ContentCollection.self,
            ContentItem.self,
            User.self,
            Page.self,
            Question.self,
            MyStatistics.self,
            SystemSetting.self,
            UserSetting.self,
            UserChoice.self,
            Partner.self,
            MyToBeVision.self
        ]
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
        NotificationHandler.postNotification(withName: .syncStartedNotification, userInfo: [
            "isSyncRecordsValid": isSyncRecordsValid
            ])
        
        let context = SyncContext(queue: operationQueue) { (state, errors) in
            switch state {
            case .finished:
                DispatchQueue.main.async {
                    NotificationHandler.postNotification(withName: .syncFinishedNotification)
                    print("SYNC ALL FINISHED with \(errors.count) errors")
                    errors.forEach({ (error: SyncError) in
                        print(error)
                    })
                }
            default:
                break
            }
        }

        let operations: [Operation] = [
            downSyncOperation(for: SystemSetting.self, context: context),
            downSyncOperation(for: UserSetting.self, context: context),
            downSyncOperation(for: User.self, context: context),
            downSyncOperation(for: Question.self, context: context),
            downSyncOperation(for: Page.self, context: context),
            downSyncOperation(for: UserChoice.self, context: context),
            downSyncOperation(for: ContentCategory.self, context: context),
            downSyncOperation(for: ContentCollection.self, context: context),
            downSyncOperation(for: MyStatistics.self, context: context),
            downSyncOperation(for: ContentItem.self, context: context),
            downSyncOperation(for: Partner.self, context: context),
            downSyncOperation(for: MyToBeVision.self, context: context),
            UpdateRelationsOperation(context: context, realmProvider: realmProvider, isFinalOperation: true)
        ]

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    func upSyncAll() {
        let context = SyncContext(queue: operationQueue) { (state, errors) in
            switch state {
            case .finished:
                print("UP SYNC ALL FINISHED with \(errors.count) errors")
                errors.forEach({ (error: SyncError) in
                    print(error)
                })
            default:
                break
            }
        }

        let operations: [Operation] = [
            upSyncOperation(CalendarEvent.self, context: context),
            upSyncOperation(MyToBeVision.self, context: context),
            upSyncOperation(Partner.self, context: context),
            upSyncOperation(User.self, context: context, isFinalOperation: true)
        ]

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    private func downSyncOperation<P>(for: P.Type, context: SyncContext, isFinalOperation: Bool = false) -> DownSyncOperation<P> where P: DownSyncable, P: Object {
        return DownSyncOperation<P>(context: context,
                                 networkManager: networkManager,
                                 syncRecordService: syncRecordService,
                                 realmProvider: realmProvider,
                                 downSyncImporter: DownSyncImporter(),
                                 isFinalOperation: isFinalOperation)
    }

    private func upSyncOperation<T>(_ type: T.Type,
                                    context: SyncContext,
                                    isFinalOperation: Bool = false) -> UpSyncOperation<T> where T: Object, T: UpSyncable {
        return UpSyncOperation<T>(networkManager: networkManager,
                                  realmProvider: realmProvider,
                                  syncContext: context,
                                  isFinalOperation: isFinalOperation)
    }
}

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

extension Notification.Name {
    static let startUpSyncMediaNotification = Notification.Name(rawValue: "qot_startUpSyncMediaNotification")
}

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
    var isSyncingAll: Bool = false
    var isUpSyncingAll: Bool = false
    var isUpSyncingMedia: Bool = false
    
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
        
        setupNotifications()
    }
    
    deinit {
        tearDownNotifications()
    }

    func clearAll() throws {
        operationQueue.cancelAllOperations()
        let realm = try realmProvider.realm()
        try realm.write {
            realm.deleteAll()
        }
    }
    
    func syncAll() {
        isSyncingAll = true
        
        NotificationHandler.postNotification(withName: .syncStartedNotification, userInfo: [
            "isSyncRecordsValid": isSyncRecordsValid
            ])
        
        let context = SyncContext(queue: operationQueue) { (state, errors) in
            switch state {
            case .finished:
                DispatchQueue.main.async {
                    self.isSyncingAll = false
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
            downSyncOperation(for: Preparation.self, context: context),
            UpdateRelationsOperation(context: context, realmProvider: realmProvider, isFinalOperation: true)
        ]

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    func upSyncAll() {
        isUpSyncingAll = true
        
        let context = SyncContext(queue: operationQueue) { (state, errors) in
            switch state {
            case .finished:
                self.isUpSyncingAll = false
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
            upSyncOperation(Preparation.self, context: context),
            upSyncOperation(UserChoice.self, context: context),
            upSyncOperation(UserSetting.self, context: context),
            upSyncOperation(UserAnswer.self, context: context),
            upSyncOperation(User.self, context: context, isFinalOperation: true)
        ]

        operationQueue.addOperations(operations, waitUntilFinished: false)
        
        upSyncMedia()
    }
    
    @objc func upSyncMedia() {
        isUpSyncingMedia = true
        
        let context = SyncContext(queue: operationQueue) { (state, errors) in
            switch state {
            case .finished:
                self.isUpSyncingMedia = false
                print("UP SYNC MEDIA FINISHED with \(errors.count) errors")
                errors.forEach({ (error: SyncError) in
                    print(error)
                })
            default:
                break
            }
        }
        
        do {
            let realm = try realmProvider.realm()
            let itemsToUpload = realm.objects(MediaResource.self).filter(MediaResource.dirtyPredicate)
            let operations: [Operation] = itemsToUpload.map({ (resource: MediaResource) -> Operation in
                return upSyncMediaOperation(forItem: resource, context: context, isFinalOperation: (resource == itemsToUpload.last))
            })
            operationQueue.addOperations(operations, waitUntilFinished: false)
        } catch {}
    }

    // MARK: - private
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(upSyncMedia), name: .startUpSyncMediaNotification, object: nil)
    }
    
    private func tearDownNotifications() {
        NotificationCenter.default.removeObserver(self, name: .startUpSyncMediaNotification, object: nil)
    }
    
    private func downSyncOperation<P>(for: P.Type, context: SyncContext, isFinalOperation: Bool = false) -> DownSyncOperation<P> where P: DownSyncable, P: SyncableObject {
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
    
    private func upSyncMediaOperation(forItem item: MediaResource,
                                      context: SyncContext,
                                      isFinalOperation: Bool = false) -> UpSyncMediaOperation {
        return UpSyncMediaOperation(networkManager: networkManager,
                                    realmProvider: realmProvider,
                                    syncContext: context,
                                    item: item,
                                    isFinalOperation: isFinalOperation)
    }
}

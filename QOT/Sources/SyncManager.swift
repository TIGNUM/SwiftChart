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

// Callback notifications
extension Notification.Name {
    static let syncAllDidStartNotification = Notification.Name(rawValue: "qot_syncAllDidStartNotification") // userInfo -> { isDownloadRecordsValid : Bool }
    static let syncAllDidFinishNotification = Notification.Name(rawValue: "qot_syncAllDidFinishNotification")
}

// Command notifications
extension Notification.Name {
    static let startSyncAllNotification = Notification.Name(rawValue: "qot_startSyncAllNotification")
    static let startSyncUploadMediaNotification = Notification.Name(rawValue: "qot_startSyncUploadMediaNotification")
    static let startSyncUploadNonMediaNotification = Notification.Name(rawValue: "qot_startSyncUploadNonMediaNotification")
}

final class SyncManager {

    private let networkManager: NetworkManager
    private let syncRecordService: SyncRecordService
    private let realmProvider: RealmProvider
    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    private var syncAllTimer: Timer?
    private var uploadTimer: Timer?

    @objc var isDownloadRecordsValid: Bool {
        do {
            // There are some classes that must have downloaded to use the app. We only care about those classes
            let downloadClasses: [AnyClass] = [
                SystemSetting.self,
                UserSetting.self,
                User.self,
                Question.self,
                ContentCategory.self,
                ContentCollection.self,
                Statistics.self,
                ContentItem.self
            ]
            for value in downloadClasses {
                guard try syncRecordService.lastSync(className: String(describing: value.self)) > 0 else {
                    return false
                }
            }
        } catch {
            return false
        }
        return true
    }

    var isSyncing: Bool {
        return operationQueue.operationCount > 0
    }

    init(networkManager: NetworkManager, syncRecordService: SyncRecordService, realmProvider: RealmProvider) {
        self.networkManager = networkManager
        self.syncRecordService = syncRecordService
        self.realmProvider = realmProvider
        
        setupNotifications()
    }

    deinit {
        tearDownTimers()
    }

    // MARK: Private

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(startSyncAllNotification(_:)), name: .startSyncAllNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startSyncUploadNonMediaNotification(_:)), name: .startSyncUploadNonMediaNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startSyncUploadMediaNotification(_:)), name: .startSyncUploadMediaNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification(_:)), name: .UIApplicationWillEnterForeground, object: nil)
    }

    private func setupTimers() {
        syncAllTimer = Timer.scheduledTimer(withTimeInterval: 60.0 * 60.0 * 10.0 /* 10 mins */, repeats: true) { [unowned self] (timer: Timer) in
            self.syncAll(shouldDownload: true)
            self.uploadMedia()
        }
        uploadTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [unowned self] (timer: Timer) in
            self.syncAll(shouldDownload: false)
            self.uploadMedia()
        }
    }

    private func tearDownTimers() {
        syncAllTimer?.invalidate()
        syncAllTimer = nil

        uploadTimer?.invalidate()
        uploadTimer = nil
    }

    // MARK: Syncs

    func startAutoSync() {
        #if BUILD_DATABASE
            return // Don't do regular sync when building seed database
        #endif

        setupTimers()
    }

    func stopAutoSync() {
        tearDownTimers()
    }

    func stopCurrentSync() {
        operationQueue.cancelAllOperations()
    }

    func syncAll(shouldDownload: Bool) {
        let context = SyncContext()

        let startOperation = BlockOperation { [unowned self] in
            DispatchQueue.main.async {
                let key = NSStringFromSelector(#selector(getter: self.isDownloadRecordsValid))
                let userInfo = [key: self.isDownloadRecordsValid]
                NotificationHandler.postNotification(withName: .syncAllDidStartNotification, userInfo: userInfo)
                log("SYNC ALL STARTED", enabled: Log.Toggle.Manager.Sync)
            }
        }
        let finishOperation = BlockOperation {
            DispatchQueue.main.async {
                let errors = context.errors
                NotificationHandler.postNotification(withName: .syncAllDidFinishNotification)
                log("SYNC ALL FINISHED with \(errors.count) errors", enabled: Log.Toggle.Manager.Sync)
                errors.forEach { (error: SyncError) in
                    log(error, enabled: Log.Toggle.Manager.Sync)
                }
            }
        }

        var operations: [Operation] = [startOperation]
        operations.append(contentsOf: syncOperations(context: context, shouldDownload: shouldDownload))
        operations.append(finishOperation)

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    func uploadMedia() {
        do {
            let context = SyncContext()
            var operations: [Operation] = try uploadMediaOperations(context: context)

            guard operations.count > 0 else {
                log("UPLOAD MEDIA - NO ITEMS TO UPLOAD", enabled: Log.Toggle.Manager.Sync)
                return
            }
            let startOperation = BlockOperation {
                DispatchQueue.main.async {
                    log("UPLOAD MEDIA STARTED", enabled: Log.Toggle.Manager.Sync)
                }
            }
            let finishOperation = BlockOperation {
                DispatchQueue.main.async {
                    let errors = context.errors
                    
                    log("UPLOAD MEDIA FINISHED with \(errors.count) errors", enabled: Log.Toggle.Manager.Sync)
                    errors.forEach { (error: SyncError) in
                        log(error, enabled: Log.Toggle.Manager.Sync)
                    }
                }
            }

            operations.insert(startOperation, at: 0)
            operations.append(finishOperation)
            operationQueue.addOperations(operations, waitUntilFinished: false)
        } catch {
            log("UPLOAD MEDIA FAILED TO START: \(error)", enabled: Log.Toggle.Manager.Sync)
        }
    }

    private func syncOperations(context: SyncContext, shouldDownload: Bool) -> [Operation] {
        let operations: [Operation?] = [
            syncOperation(PageTrack.self, context: context, shouldDownload: shouldDownload),
            syncOperation(CalendarEvent.self, context: context, shouldDownload: shouldDownload),
            syncOperation(MyToBeVision.self, context: context, shouldDownload: shouldDownload),
            syncOperation(Partner.self, context: context, shouldDownload: shouldDownload),
            syncOperation(Preparation.self, context: context, shouldDownload: shouldDownload),
            syncOperation(PreparationCheck.self, context: context, shouldDownload: shouldDownload),
            syncOperation(UserChoice.self, context: context, shouldDownload: shouldDownload),
            syncOperation(UserSetting.self, context: context, shouldDownload: shouldDownload),
            syncOperation(User.self, context: context, shouldDownload: shouldDownload),
            syncOperation(UserAnswer.self, context: context, shouldDownload: shouldDownload),
            syncOperation(SystemSetting.self, context: context, shouldDownload: shouldDownload),
            syncOperation(Question.self, context: context, shouldDownload: shouldDownload),
            syncOperation(Page.self, context: context, shouldDownload: shouldDownload),
            syncOperation(ContentCategory.self, context: context, shouldDownload: shouldDownload),
            syncOperation(ContentCollection.self, context: context, shouldDownload: shouldDownload),
            syncOperation(ContentItem.self, context: context, shouldDownload: shouldDownload),
            syncOperation(Statistics.self, context: context, shouldDownload: shouldDownload),
            UpdateRelationsOperation(context: context, realmProvider: realmProvider)
        ]
        return operations.flatMap({ $0 })
    }

    private func uploadMediaOperations(context: SyncContext) throws -> [Operation] {
        let realm = try realmProvider.realm()
        let itemsToUpload = realm.objects(MediaResource.self).filter(MediaResource.dirtyPredicate)
        return itemsToUpload.map { (resource: MediaResource) -> Operation in
            return upSyncMediaOperation(localID: resource.localID, context: context)
        }
    }

    // MARK: Operation Factories

    private func syncOperation<T>(_ type: T.Type, context: SyncContext, shouldDownload: Bool)
        -> SyncOperation? where T: SyncableObject, T: UpSyncable {
            let upSyncTask = UpSyncTask<T>(networkManager: networkManager, realmProvider: realmProvider)
            return SyncOperation(upSyncTask: upSyncTask, downSyncTask: nil, syncContext: context)
    }

    private func syncOperation<T>(_ type: T.Type, context: SyncContext, shouldDownload: Bool)
        -> SyncOperation? where T: SyncableObject, T: DownSyncable, T.Data: DownSyncIntermediary {
            guard shouldDownload == true else {
                return nil
            }
            let downSyncTask = DownSyncTask<T>(networkManager: networkManager,
                                               realmProvider: realmProvider,
                                               syncRecordService: syncRecordService)
            return SyncOperation(upSyncTask: nil, downSyncTask: downSyncTask, syncContext: context)
    }

    private func syncOperation<T>(_ type: T.Type, context: SyncContext, shouldDownload: Bool)
        -> SyncOperation? where T: SyncableObject, T: UpSyncable, T: DownSyncable, T.Data: DownSyncIntermediary {
            let upSyncTask = UpSyncTask<T>(networkManager: networkManager, realmProvider: realmProvider)
            let downSyncTask: SyncTask?
            if shouldDownload == true {
                downSyncTask = DownSyncTask<T>(networkManager: networkManager,
                                                realmProvider: realmProvider,
                                                syncRecordService: syncRecordService)
            } else {
                downSyncTask = nil
            }
            return SyncOperation(upSyncTask: upSyncTask, downSyncTask: downSyncTask, syncContext: context)
    }

    private func upSyncMediaOperation(localID: String, context: SyncContext) -> UpSyncMediaOperation {
        return UpSyncMediaOperation(networkManager: networkManager,
                                    realmProvider: realmProvider,
                                    syncContext: context,
                                    localID: localID)
    }

    // MARK: Notifications
    
    @objc private func startSyncAllNotification(_ notification: Notification) {
        syncAll(shouldDownload: true)
        uploadMedia()
    }
    
    @objc private func startSyncUploadMediaNotification(_ notification: Notification) {
        uploadMedia()
    }
    
    @objc private func startSyncUploadNonMediaNotification(_ notification: Notification) {
        syncAll(shouldDownload: false)
    }
    
    @objc private func willEnterForegroundNotification(_ notification: Notification) {
        syncAll(shouldDownload: true)
        uploadMedia()
    }
}

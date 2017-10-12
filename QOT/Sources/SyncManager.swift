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
    static let startSyncDownloadNotification = Notification.Name(rawValue: "qot_startSyncDownloadNotification")
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
                MyStatistics.self,
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
        NotificationCenter.default.addObserver(self, selector: #selector(startSyncDownloadNotification(_:)), name: .startSyncDownloadNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startSyncUploadNonMediaNotification(_:)), name: .startSyncUploadNonMediaNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startSyncUploadMediaNotification(_:)), name: .startSyncUploadMediaNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification(_:)), name: .UIApplicationWillEnterForeground, object: nil)
    }

    private func setupTimers() {
        syncAllTimer = Timer.scheduledTimer(withTimeInterval: 60.0 * 60.0 * 10.0 /* 10 mins */, repeats: true) { [unowned self] (timer: Timer) in
            self.syncAll()
            self.uploadMedia()
        }
        uploadTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [unowned self] (timer: Timer) in
            self.uploadNonMedia()
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

    func syncAll() {
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
        operations.append(contentsOf: allUpSyncOperations(context: context))
        operations.append(contentsOf: allDownSyncOperations(context: context))
        operations.append(finishOperation)

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    func download() {
        let context = SyncContext()
        
        let startOperation = BlockOperation {
            log("DOWNLOAD STARTED", enabled: Log.Toggle.Manager.Sync)
        }
        let finishOperation = BlockOperation {
            DispatchQueue.main.async {
                let errors = context.errors
                log("DOWNLOAD FINISHED with \(errors.count) errors", enabled: Log.Toggle.Manager.Sync)
                errors.forEach { (error: SyncError) in
                    log(error, enabled: Log.Toggle.Manager.Sync)
                }
            }
        }
        
        var operations: [Operation] = [startOperation]
        operations.append(contentsOf: allDownSyncOperations(context: context))
        operations.append(finishOperation)
        
        operationQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    func uploadNonMedia() {
        let context = SyncContext()
        
        let startOperation = BlockOperation {
            log("UPLOAD NON MEDIA STARTED", enabled: Log.Toggle.Manager.Sync)
        }
        let finishOperation = BlockOperation {
            DispatchQueue.main.async {
                let errors = context.errors
                log("UPLOAD NON MEDIA FINISHED with \(errors.count) errors", enabled: Log.Toggle.Manager.Sync)
                errors.forEach { (error: SyncError) in
                    log(error, enabled: Log.Toggle.Manager.Sync)
                }
            }
        }
        
        var operations: [Operation] = [startOperation]
        operations.append(contentsOf: allUpSyncOperations(context: context))
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

    private func allUpSyncOperations(context: SyncContext) -> [Operation] {
        return [
            upSyncOperation(CalendarEvent.self, context: context),
            upSyncOperation(MyToBeVision.self, context: context),
            upSyncOperation(Partner.self, context: context),
            upSyncOperation(Preparation.self, context: context),
            upSyncOperation(PreparationCheck.self, context: context),
            upSyncOperation(UserChoice.self, context: context),
            upSyncOperation(UserSetting.self, context: context),
            upSyncOperation(User.self, context: context),
            upSyncOperation(PageTrack.self, context: context),
            upSyncOperation(UserAnswer.self, context: context)
        ]
    }

    private func allDownSyncOperations(context: SyncContext) -> [Operation] {
        return [
            // @warning also add to isDownloadRecordsValid
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
            downSyncOperation(for: PreparationCheck.self, context: context),
            UpdateRelationsOperation(context: context, realmProvider: realmProvider)
        ]
    }

    private func uploadMediaOperations(context: SyncContext) throws -> [Operation] {
        let realm = try realmProvider.realm()
        let itemsToUpload = realm.objects(MediaResource.self).filter(MediaResource.dirtyPredicate)
        return itemsToUpload.map { (resource: MediaResource) -> Operation in
            return upSyncMediaOperation(localID: resource.localID, context: context)
        }
    }

    // MARK: Operation Factories

    private func downSyncOperation<P>(for: P.Type, context: SyncContext) -> DownSyncOperation<P> where P: DownSyncable, P: SyncableObject {
        return DownSyncOperation<P>(context: context,
                                    networkManager: networkManager,
                                    syncRecordService: syncRecordService,
                                    realmProvider: realmProvider,
                                    downSyncImporter: DownSyncImporter())
    }

    private func upSyncOperation<T>(_ type: T.Type, context: SyncContext) -> UpSyncOperation<T> where T: Object, T: UpSyncable {
        return UpSyncOperation<T>(networkManager: networkManager,
                                  realmProvider: realmProvider,
                                  syncContext: context)
    }

    private func upSyncMediaOperation(localID: String, context: SyncContext) -> UpSyncMediaOperation {
        return UpSyncMediaOperation(networkManager: networkManager,
                                    realmProvider: realmProvider,
                                    syncContext: context,
                                    localID: localID)
    }

    // MARK: Notifications
    
    @objc private func startSyncAllNotification(_ notification: Notification) {
        syncAll()
        uploadMedia()
    }
    
    @objc private func startSyncDownloadNotification(_ notification: Notification) {
        download()
    }
    
    @objc private func startSyncUploadMediaNotification(_ notification: Notification) {
        uploadMedia()
    }
    
    @objc private func startSyncUploadNonMediaNotification(_ notification: Notification) {
        uploadNonMedia()
    }
    
    @objc private func willEnterForegroundNotification(_ notification: Notification) {
        syncAll()
        uploadMedia()
    }
}

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
import Alamofire

// Callback notifications
extension Notification.Name {
    static let syncAllDidStartNotification = Notification.Name(rawValue: "qot_syncAllDidStartNotification")
    static let syncAllDidFinishNotification = Notification.Name(rawValue: "qot_syncAllDidFinishNotification")
}

// Command notifications
extension Notification.Name {
    static let startSyncAllNotification = Notification.Name(rawValue: "qot_startSyncAllNotification")
    static let startSyncUploadMediaNotification = Notification.Name(rawValue: "qot_startSyncUploadMediaNotification")
}

final class SyncManager {

    // MARK: - Private Storage

    let syncRecordService: SyncRecordService
    private let networkManager: NetworkManager
    private let realmProvider: RealmProvider
    private let reachability = NetworkReachabilityManager()
    private var syncAllTimer: Timer?
    private var uploadTimer: Timer?
    private var syncTask: SyncTask?
    private var enabled = false
    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    // MARK: - Init

    init(networkManager: NetworkManager, syncRecordService: SyncRecordService, realmProvider: RealmProvider) {
        self.networkManager = networkManager
        self.syncRecordService = syncRecordService
        self.realmProvider = realmProvider

        reachability?.listener = { [weak self] (status) -> Void in
            switch status {
            case .unknown, .reachable:
                self?.syncAll(shouldDownload: true)
                self?.uploadMedia()
            case .notReachable:
                break
            }
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForegroundNotification(_:)),
                                               name: .UIApplicationWillEnterForeground, object: nil)
    }

    deinit {
        stop()
    }

    // MARK: - Public

    var isSyncing: Bool {
        return operationQueue.operationCount > 0
    }

    func start() {
        enabled = true
        syncAll(shouldDownload: true)
        uploadMedia()
        reachability?.startListening()
        startSyncTimers()
        startObservingSyncNotifications()
    }

    func stop() {
        enabled = false
        stopCurrentSync()
        reachability?.stopListening()
        stopSyncTimers()
        stopObservingSyncNotifications()
    }

    func downSyncUser(completion: @escaping (Error?) -> Void) {
        syncTask = DownSyncTask<User>(networkManager: networkManager,
                                      realmProvider: realmProvider,
                                      syncRecordService: syncRecordService)
        syncTask?.start { (error) in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }

    func stopCurrentSync() {
        syncTask?.cancel()
        operationQueue.cancelAllOperations()
    }

    func syncAll(shouldDownload: Bool) {
        let context = SyncContext()

        let startOperation = BlockOperation {
            DispatchQueue.main.async {
                NotificationHandler.postNotification(withName: .syncAllDidStartNotification)
                log("SYNC ALL STARTED", enabled: Log.Toggle.Manager.Sync)
            }
        }
        let finishOperation = BlockOperation {
            DispatchQueue.main.async {
                // FIXME: remove when real data is available
                if let realm = try? self.realmProvider.realm() {
                    try? realm.write {
                        realm.create(Statistics.self, value: Statistics._meetingsNumberAverage, update: true)
                    }
                }

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
}

private extension SyncManager {

    func startSyncTimers() {
        #if BUILD_DATABASE
            return // Don't do regular sync when building seed database
        #endif

        func startSyncTimer(timeInterval: TimeInterval, shouldDownload: Bool) -> Timer {
            return Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [unowned self] _ in
                self.syncAll(shouldDownload: shouldDownload)
                self.uploadMedia()
            }
        }
        syncAllTimer = startSyncTimer(timeInterval: 60.0 * 60.0 * 10.0 /* 10 mins */, shouldDownload: true)
        uploadTimer = startSyncTimer(timeInterval: 60.0, shouldDownload: false)
    }

    func stopSyncTimers() {
        [syncAllTimer, uploadTimer].forEach { $0?.invalidate() }
        syncAllTimer = nil
        uploadTimer = nil
    }

    func startObservingSyncNotifications() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(startSyncAllNotification(_:)), name: .startSyncAllNotification, object: nil)
        center.addObserver(self, selector: #selector(startSyncUploadMediaNotification(_:)), name: .startSyncUploadMediaNotification, object: nil)
    }

    func stopObservingSyncNotifications() {
        let center = NotificationCenter.default
        center.removeObserver(self, name: .startSyncAllNotification, object: nil)
        center.removeObserver(self, name: .startSyncUploadMediaNotification, object: nil)
    }

    func syncOperations(context: SyncContext, shouldDownload: Bool) -> [Operation] {
        let operations: [Operation?] = [
            syncOperation(ContentRead.self, context: context, shouldDownload: shouldDownload),
            UpdateRelationsOperation(context: context, realmProvider: realmProvider),
            syncOperation(PageTrack.self, context: context, shouldDownload: shouldDownload),
            syncOperation(CalendarEvent.self, context: context, shouldDownload: shouldDownload),
            syncOperation(MyToBeVision.self, context: context, shouldDownload: shouldDownload),
            syncOperation(Statistics.self, context: context, shouldDownload: shouldDownload),
            syncOperation(Partner.self, context: context, shouldDownload: shouldDownload),
            syncOperation(Preparation.self, context: context, shouldDownload: shouldDownload),
            syncOperation(PreparationCheck.self, context: context, shouldDownload: shouldDownload),
            syncOperation(UserChoice.self, context: context, shouldDownload: shouldDownload),
            syncOperation(UserSetting.self, context: context, shouldDownload: shouldDownload),
            syncOperation(User.self, context: context, shouldDownload: shouldDownload),
            syncOperation(UserAnswer.self, context: context, shouldDownload: shouldDownload),
            syncOperation(UserFeedback.self, context: context, shouldDownload: shouldDownload),
            syncOperation(SystemSetting.self, context: context, shouldDownload: shouldDownload),
            syncOperation(Question.self, context: context, shouldDownload: shouldDownload),
            syncOperation(Page.self, context: context, shouldDownload: shouldDownload),
            syncOperation(ContentCategory.self, context: context, shouldDownload: shouldDownload),
            syncOperation(ContentCollection.self, context: context, shouldDownload: shouldDownload),
            syncOperation(ContentItem.self, context: context, shouldDownload: shouldDownload),
            UpdateRelationsOperation(context: context, realmProvider: realmProvider)
        ]
        return operations.flatMap({ $0 })
    }

    func uploadMediaOperations(context: SyncContext) throws -> [Operation] {
        let realm = try realmProvider.realm()
        let itemsToUpload = realm.objects(MediaResource.self).filter(MediaResource.dirtyPredicate)
        return itemsToUpload.map { (resource: MediaResource) -> Operation in
            return upSyncMediaOperation(localID: resource.localID, context: context)
        }
    }

    // MARK: Operation Factories

    func syncOperation<T>(_ type: T.Type, context: SyncContext, shouldDownload: Bool)
        -> SyncOperation? where T: SyncableObject, T: UpSyncable {
            let upSyncTask = UpSyncTask<T>(networkManager: networkManager, realmProvider: realmProvider)
            return SyncOperation(upSyncTask: upSyncTask, downSyncTask: nil, syncContext: context)
    }

    func syncOperation<T>(_ type: T.Type, context: SyncContext, shouldDownload: Bool)
        -> SyncOperation? where T: SyncableObject, T: DownSyncable, T.Data: DownSyncIntermediary {
            guard shouldDownload == true else {
                return nil
            }
            let downSyncTask = DownSyncTask<T>(networkManager: networkManager,
                                               realmProvider: realmProvider,
                                               syncRecordService: syncRecordService)
            return SyncOperation(upSyncTask: nil, downSyncTask: downSyncTask, syncContext: context)
    }

    func syncOperation<T>(_ type: T.Type, context: SyncContext, shouldDownload: Bool)
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

    func upSyncMediaOperation(localID: String, context: SyncContext) -> UpSyncMediaOperation {
        return UpSyncMediaOperation(networkManager: networkManager,
                                    realmProvider: realmProvider,
                                    syncContext: context,
                                    localID: localID)
    }

    // MARK: Notifications

    @objc func startSyncAllNotification(_ notification: Notification) {
        syncAll(shouldDownload: true)
        uploadMedia()
    }

    @objc func startSyncUploadMediaNotification(_ notification: Notification) {
        uploadMedia()
    }

    @objc func willEnterForegroundNotification(_ notification: Notification) {
        guard enabled == true else { return }

        syncAll(shouldDownload: true)
        uploadMedia()
    }
}

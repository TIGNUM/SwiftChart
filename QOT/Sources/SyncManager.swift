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
import Alamofire

// Callback notifications
extension Notification.Name {
    static let syncAllDidStartNotification = Notification.Name(rawValue: "qot_syncAllDidStartNotification")
    static let syncAllDidFinishNotification = Notification.Name(rawValue: "qot_syncAllDidFinishNotification")
    static let didDismissView = Notification.Name(rawValue: "qot_didDismissView")
}

// Command notifications
extension Notification.Name {
    static let startSyncAllNotification = Notification.Name(rawValue: "qot_startSyncAllNotification")
    static let startSyncUploadMediaNotification = Notification.Name(rawValue: "qot_startSyncUploadMediaNotification")
    static let startSyncCalendarRelatedData = Notification.Name(rawValue: "qot_startSyncCalendarRelatedData")
    static let startSyncPreparationRelatedData = Notification.Name(rawValue: "qot_startSyncPreparationRelatedData")
    static let startSyncConversionRelatedData = Notification.Name(rawValue: "qot_startSyncConversionRelatedData")
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
    private var nextAllSyncTime: Date = Date(timeIntervalSince1970: 0)
    private let allSyncOperationQueue: OperationQueue
    private let operationQueue: OperationQueue
    var isSynchronsingPreparation = false

    // MARK: - Init

    init(networkManager: NetworkManager,
         syncRecordService: SyncRecordService,
         realmProvider: RealmProvider) {
        self.networkManager = networkManager
        self.syncRecordService = syncRecordService
        self.realmProvider = realmProvider
        self.allSyncOperationQueue = OperationQueue()
        self.operationQueue = OperationQueue()
        self.allSyncOperationQueue.maxConcurrentOperationCount = 1
        self.operationQueue.maxConcurrentOperationCount = 1

        reachability?.listener = { [weak self] (status) -> Void in
            switch status {
            case .unknown, .reachable:
                self?.syncAll(shouldDownload: true)
            case .notReachable:
                break
            }
        }
    }

    deinit {
        stop()
    }

    // MARK: - Public

    var isSyncingAll: Bool {
        return allSyncOperationQueue.operationCount > 0
    }

    func start() {
        enabled = true
        syncAll(shouldDownload: true)
        reachability?.startListening()
    }

    func stop() {
        enabled = false
        stopCurrentSync()
        reachability?.stopListening()
        stopSyncTimers()
        stopObservingSyncNotifications()
    }

    func downSyncUser(completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.async {
            completion(nil)
        }
    }

    func stopCurrentSync() {
        syncTask?.cancel()
        operationQueue.cancelAllOperations()
    }

    func syncAll(shouldDownload: Bool, completion: ((Error?) -> Void)? = nil) {
        completion?(nil)
    }

    func syncUserDependentData(syncContext: SyncContext? = nil, completion: ((Error?) -> Void)? = nil) {
        DispatchQueue.main.async {
            completion?(nil)
        }
    }

    func syncUserAnswers() {
    }

    func syncForSharing(completion: ((Error?) -> Void)? = nil) {
        DispatchQueue.main.async {
            completion?(nil)
        }
    }

    func syncMyToBeVision(completion: ((Error?) -> Void)? = nil) {
        DispatchQueue.main.async {
            completion?(nil)
        }
    }

    func syncPartners(completion: ((Error?) -> Void)? = nil) {
        DispatchQueue.main.async {
            completion?(nil)
        }
    }

    func syncConversions(syncContext: SyncContext? = nil, completion: ((Error?) -> Void)? = nil) {
        DispatchQueue.main.async {
            completion?(nil)
        }
    }

    func uploadMedia() {
    }
}

private extension SyncManager {

    func stopSyncTimers() {
        [syncAllTimer, uploadTimer].forEach { $0?.invalidate() }
        syncAllTimer = nil
        uploadTimer = nil
    }

    func stopObservingSyncNotifications() {
        let center = NotificationCenter.default
        center.removeObserver(self, name: .startSyncAllNotification, object: nil)
        center.removeObserver(self, name: .startSyncUploadMediaNotification, object: nil)
    }

    func uploadMediaOperations(context: SyncContext) throws -> [Operation] {
        let realm = try realmProvider.realm()
        let itemsToUpload = realm.objects(MediaResource.self).filter("syncStatusValue != -1")
        return itemsToUpload.map { (resource: MediaResource) -> Operation in
            return upSyncMediaOperation(localID: resource.localID, context: context)
        }
    }

    // MARK: Operation Factories

    func syncOperation<T>(_ type: T.Type, context: SyncContext, shouldDownload: Bool)
        -> SyncOperation? where T: SyncableObject, T: UpSyncable {
            let upSyncTask = UpSyncTask<T>(networkManager: networkManager, realmProvider: realmProvider)
            return SyncOperation(upSyncTask: upSyncTask,
                                 downSyncTask: nil,
                                 syncContext: context,
                                 debugIdentifier: String(describing: type))
    }

    func syncOperation<T>(_ type: T.Type, context: SyncContext, shouldDownload: Bool)
        -> SyncOperation? where T: SyncableObject, T: DownSyncable, T.Data: DownSyncIntermediary {
            guard shouldDownload == true else {
                return nil
            }
            let downSyncTask = DownSyncTask<T>(networkManager: networkManager,
                                               realmProvider: realmProvider,
                                               syncRecordService: syncRecordService)
            return SyncOperation(upSyncTask: nil,
                                 downSyncTask: downSyncTask,
                                 syncContext: context,
                                 debugIdentifier: String(describing: type))
    }

    func syncOperation<T>(_ type: T.Type, context: SyncContext, shouldDownload: Bool)
        -> SyncOperation? where T: SyncableObject, T: UpSyncable, T: DownSyncable, T.Data: DownSyncIntermediary {
            let upSyncTask = UpSyncTask<T>(networkManager: networkManager, realmProvider: realmProvider)
            let downSyncTask: DownSyncTask<T>?
            if shouldDownload == true {
                downSyncTask = DownSyncTask<T>(networkManager: networkManager,
                                               realmProvider: realmProvider,
                                               syncRecordService: syncRecordService)
            } else {
                downSyncTask = nil
            }
            return SyncOperation(upSyncTask: upSyncTask,
                                 downSyncTask: downSyncTask,
                                 syncContext: context,
                                 debugIdentifier: String(describing: type))
    }

    func upSyncMediaOperation(localID: String, context: SyncContext) -> UpSyncMediaOperation {
        return UpSyncMediaOperation(networkManager: networkManager,
                                    realmProvider: realmProvider,
                                    syncContext: context,
                                    localID: localID)
    }

    func operationBlock(context: SyncContext?, completion: ((Error?) -> Void)? = nil) -> Operation {
        return BlockOperation {
            DispatchQueue.main.async {
                let errors = context?.errors
                errors?.forEach { (error: SyncError) in
                    log(error, level: .debug)
                }
                completion?(errors?.first)
            }
        }
    }

    func excute(operations: [Operation?], context: SyncContext, completion: ((Error?) -> Void)? = nil) {
        var givenOperations = operations
        let context = SyncContext()
        let finishOperation: Operation? = (completion != nil) ? operationBlock(context: context, completion: completion) : nil
        if finishOperation != nil {
            for operation in givenOperations.compactMap({ $0 }) {
                finishOperation!.addDependency(operation)
            }
            givenOperations.append(finishOperation)
        }
        operationQueue.addOperations(givenOperations.compactMap({ $0 }), waitUntilFinished: false)
    }
}

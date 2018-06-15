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

    var userNotificationsManager: UserNotificationsManager?

    // MARK: - Init

    init(networkManager: NetworkManager,
         syncRecordService: SyncRecordService,
         realmProvider: RealmProvider) {
        self.networkManager = networkManager
        self.syncRecordService = syncRecordService
        self.realmProvider = realmProvider
        self.allSyncOperationQueue = OperationQueue()
        self.operationQueue = OperationQueue()
        #if BUILD_DATABASE
        self.allSyncOperationQueue.maxConcurrentOperationCount = 1
        self.operationQueue.maxConcurrentOperationCount = 1
        #else
        self.allSyncOperationQueue.maxConcurrentOperationCount = 3
        self.operationQueue.maxConcurrentOperationCount = 3
        #endif //

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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterBackgroundNotification(_:)),
                                               name: .UIApplicationDidEnterBackground, object: nil)
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

    func syncAll(shouldDownload: Bool, completion: ((Error?) -> Void)? = nil) {
        if isSyncingAll {
            completion?(nil)
            return
        }
        stopSyncTimers()
        startSyncTimers()
        nextAllSyncTime = Date(timeIntervalSinceNow: 60 * 10) // in next 10 minutes.
        let context = SyncContext()

        let startOperation = operationBlock(context: nil) { (error) in
            NotificationHandler.postNotification(withName: .syncAllDidStartNotification)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            log("SYNC ALL STARTED", level: .debug)
        }

        let finishOperation = operationBlock(context: nil) { (error) in
            self.syncUserDependentData(syncContext: context, completion: { (error) in
                NotificationHandler.postNotification(withName: .syncAllDidFinishNotification)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                log("SYNC ALL FINISHED with \(error == nil ? "some" : "No") errors", level: .debug)
                completion?(error)
            })
        }

        startOperation.queuePriority = .high
        var operations: [Operation] = [startOperation]
        operations.append(contentsOf: userIndependentSyncOperations(context: context))
        operations.append(contentsOf: conversionSyncOperations(context: context))
        operations.append(UpdateRelationsOperation(context: context, realmProvider: realmProvider))
        for operation in operations {
            finishOperation.addDependency(operation)
        }
        operations.append(finishOperation)
        allSyncOperationQueue.addOperations(operations, waitUntilFinished: false)
    }

    func syncUserDependentData(syncContext: SyncContext? = nil, completion: ((Error?) -> Void)? = nil) {
        if isSyncingAll {
            completion?(nil)
            return
        }
        let context = syncContext ?? SyncContext()
        let operations: [Operation] = userDependentSyncOperations(context: context)
        excute(operations: operations, context: context, completion: { (error) in
            self.syncPreparations(completion: completion)
        })
    }

    func syncUserAnswers() {
        let context = SyncContext()
        let userAnswerOperation = syncOperation(UserAnswer.self, context: context, shouldDownload: true)
        let dailyPrepResultOperation = syncOperation(DailyPrepResultObject.self, context: context, shouldDownload: true)
        if userAnswerOperation != nil { dailyPrepResultOperation?.addDependency(userAnswerOperation!) }
        excute(operations: [userAnswerOperation, dailyPrepResultOperation].compactMap({ $0 }),
               context: context, completion: nil)
    }

    func syncForSharing(completion: ((Error?) -> Void)? = nil) {
        let context = SyncContext()
        excute(operations: [syncOperation(MyToBeVision.self, context: context, shouldDownload: true),
                            syncOperation(UserChoice.self, context: context, shouldDownload: true),
                            syncOperation(Partner.self, context: context, shouldDownload: true)], context: context, completion: completion)
        uploadMedia()
    }

    func syncMyToBeVision(completion: ((Error?) -> Void)? = nil) {
        let context = SyncContext()
        excute(operations: [syncOperation(MyToBeVision.self, context: context, shouldDownload: true)], context: context, completion: completion)
        uploadMedia()
    }

    func syncPartners(completion: ((Error?) -> Void)? = nil) {
        let context = SyncContext()
        var operations: [Operation?] = [syncOperation(Partner.self, context: context, shouldDownload: true)]

        do {
            let mediaUploadOperations: [Operation] = try uploadMediaOperations(context: context)
            if mediaUploadOperations.count > 0 {
                operations.append(contentsOf: mediaUploadOperations)
            }
        } catch {
            log("Failed to synchronise partners with error: \(error)")
        }
        excute(operations: operations, context: context, completion: completion)
    }

    func syncCalendarEvents(completion: ((Error?) -> Void)? = nil) {
        let context = SyncContext()
        excute(operations: [syncOperation(CalendarEvent.self, context: context, shouldDownload: true)], context: context, completion: completion)
    }

    func syncCalendarSyncSettings(completion: ((Error?) -> Void)? = nil) {
        let context = SyncContext()
        excute(operations: [syncOperation(RealmCalendarSyncSetting.self, context: context, shouldDownload: true)], context: context, completion: completion)
    }

    func syncPreparations(completion: ((Error?) -> Void)? = nil) {
        let context = SyncContext()
        let preUpdateRelationsOperation = UpdateRelationsOperation(context: context, realmProvider: realmProvider)
        let updateRelationsOperation = UpdateRelationsOperation(context: context, realmProvider: realmProvider)
        let preperationSyncOperation = syncOperation(Preparation.self, context: context, shouldDownload: true)
        let preperationCheckSyncOperation = syncOperation(PreparationCheck.self, context: context, shouldDownload: true)
        excute(operations: [preperationSyncOperation], context: context, completion: { (error) in
            self.excute(operations: [preUpdateRelationsOperation], context: context, completion: { (error) in
                self.excute(operations: [preperationCheckSyncOperation], context: context, completion: { (error) in
                    self.excute(operations: [updateRelationsOperation], context: context, completion: completion)
                })
            })

        })
    }

    func syncConversions(syncContext: SyncContext? = nil, completion: ((Error?) -> Void)? = nil) {
        let context = syncContext ?? SyncContext()
        excute(operations: conversionSyncOperations(context: context), context: context, completion: completion)
    }

    func uploadMedia() {
        do {
            let context = SyncContext()
            var operations: [Operation] = try uploadMediaOperations(context: context)
            guard operations.count > 0 else { return }

            let startOperation = operationBlock(context: context) { (error) in
                log("UPLOAD MEDIA STARTED", level: .debug)
            }
            let finishOperation = operationBlock(context: nil) { (error) in
                log("UPLOAD MEDIA FINISHED with \(error == nil ? "some" : "No") errors", level: .debug)
            }
            operations.insert(startOperation, at: 0)
            operations.append(finishOperation)
            operationQueue.addOperations(operations, waitUntilFinished: false)
        } catch {
            log("UPLOAD MEDIA FAILED TO START: \(error)", level: .debug)
        }
    }
}

private extension SyncManager {

    func userIndependentSyncOperations(context: SyncContext) -> [Operation] {
        var operations: [Operation] = contentSyncOperations(context: context, updateRelation: false)
        operations.append(contentsOf: guideItemSyncOperations(context: context, updateRelation: true))
        let lastOperation = operations.last!
        if let questionSyncOperation = syncOperation(Question.self, context: context, shouldDownload: true) {
            questionSyncOperation.addDependency(lastOperation)
            operations.append(questionSyncOperation)
        }
        if let pageSyncOperation = syncOperation(Page.self, context: context, shouldDownload: true) {
            pageSyncOperation.addDependency(lastOperation)
            operations.append(pageSyncOperation)
        }
        return operations.compactMap({ $0 })
    }

    func contentSyncOperations(context: SyncContext, updateRelation: Bool) -> [Operation] {
        let updateRelationsOperation = updateRelation ? UpdateRelationsOperation(context: context, realmProvider: realmProvider) : nil
        let contentCategorySyncOperation = syncOperation(ContentCategory.self, context: context, shouldDownload: true)
        let contentCollectionSyncOperation = syncOperation(ContentCollection.self, context: context, shouldDownload: true)
        let contentItemSyncOperation = syncOperation(ContentItem.self, context: context, shouldDownload: true)

        // Add Operation Depedencies
        if contentItemSyncOperation != nil { updateRelationsOperation?.addDependency(contentItemSyncOperation!) }
        if contentCollectionSyncOperation != nil { updateRelationsOperation?.addDependency(contentCollectionSyncOperation!) }
        if contentItemSyncOperation != nil { updateRelationsOperation?.addDependency(contentItemSyncOperation!) }

        return [contentCategorySyncOperation, contentCollectionSyncOperation,
                contentItemSyncOperation, updateRelationsOperation].compactMap({ $0 })
    }

    func guideItemSyncOperations(context: SyncContext, updateRelation: Bool) -> [Operation] {
        let updateRelationsOperation = updateRelation ? UpdateRelationsOperation(context: context, realmProvider: realmProvider) : nil
        let scheduleNotificationOperation = BlockOperation { // Schedule Notifications
            DispatchQueue.main.async {
                let manager = self.userNotificationsManager
                manager?.scheduleNotifications()
            }
        }

        let guideItemLeanSyncOperation = syncOperation(RealmGuideItemLearn.self, context: context, shouldDownload: true)
        let guideItemNotificationSyncOperation = syncOperation(RealmGuideItemNotification.self, context: context, shouldDownload: true)
        let guidItemSyncOperation = syncOperation(RealmGuideItem.self, context: context, shouldDownload: true)

        // Add Operation Depedencies
        let lastOperation = updateRelationsOperation ?? scheduleNotificationOperation
        if updateRelationsOperation != nil { scheduleNotificationOperation.addDependency(updateRelationsOperation!) }
        if guideItemLeanSyncOperation != nil { lastOperation.addDependency(guideItemLeanSyncOperation!) }
        if guideItemNotificationSyncOperation != nil { lastOperation.addDependency(guideItemNotificationSyncOperation!) }
        if guidItemSyncOperation != nil { lastOperation.addDependency(guidItemSyncOperation!) }

        return [guideItemLeanSyncOperation, guideItemNotificationSyncOperation,
                guidItemSyncOperation, updateRelationsOperation, scheduleNotificationOperation].compactMap({ $0 })
    }

    func preparationSyncOperations(context: SyncContext) -> [Operation] {
        let preUpdateRelationsOperation = UpdateRelationsOperation(context: context, realmProvider: realmProvider)
        let updateRelationsOperation = UpdateRelationsOperation(context: context, realmProvider: realmProvider)
        let preperationSyncOperation = syncOperation(Preparation.self, context: context, shouldDownload: true)
        let preperationCheckSyncOperation = syncOperation(PreparationCheck.self, context: context, shouldDownload: true)

        // Add Operation Depedencies
        if preperationSyncOperation != nil {
            preperationCheckSyncOperation?.addDependency(preperationSyncOperation!)
            preperationCheckSyncOperation?.addDependency(preUpdateRelationsOperation)
            preUpdateRelationsOperation.addDependency(preperationSyncOperation!)
        }
        updateRelationsOperation.addDependency(preUpdateRelationsOperation)

        if preperationCheckSyncOperation != nil { updateRelationsOperation.addDependency(preperationCheckSyncOperation!) }
        return [preperationSyncOperation, preUpdateRelationsOperation, preperationCheckSyncOperation, updateRelationsOperation].compactMap({ $0 })
    }

    func calendarSyncOperations(context: SyncContext) -> [Operation] {
        let calendarSettingSyncOperation = syncOperation(RealmCalendarSyncSetting.self, context: context, shouldDownload: true)
        let calendarEventSyncOperation = syncOperation(CalendarEvent.self, context: context, shouldDownload: true)
        if calendarSettingSyncOperation != nil { calendarEventSyncOperation?.addDependency(calendarSettingSyncOperation!) }
        return [calendarSettingSyncOperation, calendarEventSyncOperation].compactMap({ $0 })
    }

    func conversionSyncOperations(context: SyncContext) -> [Operation] {
        return [syncOperation(UserFeedback.self, context: context, shouldDownload: true),
                syncOperation(ContentRead.self, context: context, shouldDownload: true),
                syncOperation(PageTrack.self, context: context, shouldDownload: true)].compactMap({ $0 })
    }

    func userDependentSyncOperations(context: SyncContext) -> [Operation] {
        var operations: [Operation?] = [syncOperation(User.self, context: context, shouldDownload: true),
                                        syncOperation(UserChoice.self, context: context, shouldDownload: true),
                                        syncOperation(UserAnswer.self, context: context, shouldDownload: true),
                                        syncOperation(MyToBeVision.self, context: context, shouldDownload: true),
                                        syncOperation(Partner.self, context: context, shouldDownload: true),
                                        syncOperation(DailyPrepResultObject.self, context: context, shouldDownload: true),
                                        syncOperation(Statistics.self, context: context, shouldDownload: true),
                                        syncOperation(UserSetting.self, context: context, shouldDownload: true),
                                        syncOperation(SystemSetting.self, context: context, shouldDownload: true)]
        operations.append(contentsOf: calendarSyncOperations(context: context))
        return operations.compactMap({ $0 })
    }

    func startSyncTimers() {
        #if BUILD_DATABASE
            return // Don't do regular sync when building seed database
        #else

        syncAllTimer = Timer.scheduledTimer(withTimeInterval: 60.0 * 10.0 /* 10 mins */, repeats: true) { [unowned self] _ in
            self.syncAll(shouldDownload: true)
            self.uploadMedia()
        }

        #endif //#if BUILD_DATABASE
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
        center.addObserver(self, selector: #selector(startSyncCalendarRelatedDataNotification(_:)), name: .startSyncCalendarRelatedData, object: nil)
        center.addObserver(self, selector: #selector(startSyncConversionRelatedDataNotification(_:)), name: .startSyncConversionRelatedData, object: nil)
        center.addObserver(self, selector: #selector(startSyncPreparationRelatedDataNotification(_:)), name: .startSyncPreparationRelatedData, object: nil)

    }

    func stopObservingSyncNotifications() {
        let center = NotificationCenter.default
        center.removeObserver(self, name: .startSyncAllNotification, object: nil)
        center.removeObserver(self, name: .startSyncUploadMediaNotification, object: nil)
    }

    func uploadMediaOperations(context: SyncContext) throws -> [Operation] {
        let realm = try realmProvider.realm()
        let itemsToUpload = realm.objects(MediaResource.self).filter("localFileName != nil")
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

    // MARK: Notifications

    @objc func startSyncAllNotification(_ notification: Notification) {
        syncAll(shouldDownload: true)
        uploadMedia()
    }

    @objc func startSyncUploadMediaNotification(_ notification: Notification) {
        uploadMedia()
    }

    @objc func startSyncCalendarRelatedDataNotification(_ notification: Notification) {
        syncCalendarSyncSettings { (error) in
            self.syncCalendarEvents()
        }
    }

    @objc func startSyncConversionRelatedDataNotification(_ notification: Notification) {
        syncConversions()
    }
    @objc func startSyncPreparationRelatedDataNotification(_ notification: Notification) {
        syncPreparations()
    }

    @objc func didEnterBackgroundNotification (_ notification: Notification) {
        stopSyncTimers()
    }

    @objc func willEnterForegroundNotification(_ notification: Notification) {
        #if BUILD_DATABASE
        return // Don't do regular sync when building seed database
        #else
        guard enabled == true else { return }

        if nextAllSyncTime < Date() {
            syncAll(shouldDownload: true)
        } else {
            syncUserDependentData()
            uploadMedia()
        }
        #endif //#if BUILD_DATABASE
    }
}

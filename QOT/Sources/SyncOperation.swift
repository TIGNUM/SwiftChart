//
//  SyncOperation.swift
//  QOT
//
//  Created by Sam Wyndham on 11.10.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class SyncOperation: ConcurrentOperation {

    private let context: SyncContext
    private let upSyncTask: SyncTask?
    private let downSyncTask: SyncTask?
    private let debugIdentifier: String

    init(upSyncTask: SyncTask?, downSyncTask: SyncTask?, syncContext: SyncContext, debugIdentifier: String) {
        precondition(upSyncTask != nil || downSyncTask != nil, "No Task")

        self.context = syncContext
        self.upSyncTask = upSyncTask
        self.downSyncTask = downSyncTask
        self.debugIdentifier = debugIdentifier
    }

    override func execute() {
        log(">>>> DID START SYNC: \(debugIdentifier)", enabled: Log.Toggle.Sync.syncOperation)
        let startDate = Date()

        if let upSyncTask = upSyncTask {
            upSyncTask.start { [weak self] (error) in
                if let downSyncTask = self?.downSyncTask, error == nil {
                    downSyncTask.start { (error) in
                        self?.finish(startDate: startDate, error: error)
                    }
                } else {
                    self?.finish(startDate: startDate, error: error)
                }
            }
        } else if let downSyncTask = downSyncTask {
            downSyncTask.start { [weak self] (error) in
                self?.finish(startDate: startDate, error: error)
            }
        } else {
            finish(startDate: startDate, error: nil)
        }
    }

    override func cancel() {
        super.cancel()

        upSyncTask?.cancel()
        downSyncTask?.cancel()
    }

    private func finish(startDate: Date, error: SyncError?) {
        let seconds = startDate.timeIntervalToNow
        log(">>>> DID FINISH SYNC: \(debugIdentifier) IN \(seconds) SECONDS", enabled: Log.Toggle.Sync.syncOperation)
        if let error = error {
            log(">>>>>>>>>>>>>> ERROR: \(error)", enabled: Log.Toggle.Sync.syncOperation)
        }

        if let error = error {
            context.add(error: error)
        }
        finish()
    }
}

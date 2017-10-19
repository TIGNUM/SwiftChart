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

    init(upSyncTask: SyncTask?, downSyncTask: SyncTask?, syncContext: SyncContext) {
        precondition(upSyncTask != nil || downSyncTask != nil, "No Task")

        self.context = syncContext
        self.upSyncTask = upSyncTask
        self.downSyncTask = downSyncTask
    }

    override func execute() {
        if let upSyncTask = upSyncTask {
            upSyncTask.start { [weak self] (error) in
                if let downSyncTask = self?.downSyncTask, error == nil {
                    downSyncTask.start { (error) in
                        self?.finish(error: error)
                    }
                } else {
                    self?.finish(error: error)
                }
            }
        } else if let downSyncTask = downSyncTask {
            downSyncTask.start { [weak self] (error) in
                self?.finish(error: nil)
            }
        } else {
            finish(error: nil)
        }
    }

    override func cancel() {
        super.cancel()

        upSyncTask?.cancel()
        downSyncTask?.cancel()
    }

    private func finish(error: SyncError?) {
        if let error = error {
            context.add(error: error)
        }
        finish()
    }
}

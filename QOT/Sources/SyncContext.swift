//
//  DownSyncContext.swift
//  QOT
//
//  Created by Sam Wyndham on 26.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum SyncError: Error {

    case downSyncReadLastSyncDateFailed(type: SyncType, error: Error)
    case downSyncStartSyncFailed(type: SyncType, error: NetworkError)
    case downSyncFetchIntermediatesFailed(type: SyncType, error: NetworkError)
    case downSyncImportChangesFailed(type: SyncType, error: Error)
    case downSyncSaveSyncDateFailed(type: SyncType, error: Error)
}

class SyncContext {

    enum State {
        case `default`
        case finished
        case errored(SyncError)
    }

    private(set) var state: State = .default
    private weak var queue: OperationQueue?

    init(queue: OperationQueue) {
        self.queue = queue
    }

    func finish(error: SyncError?) {
        if let error = error {
            state = .errored(error)
            queue?.cancelAllOperations()
        } else {
            state = .finished
        }
    }
}

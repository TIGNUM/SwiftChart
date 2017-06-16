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
    typealias Completion = ((State) -> Void)?

    enum State {
        case `default`
        case finished
        case errored(SyncError)
    }

    private(set) var state: State = .default
    private weak var queue: OperationQueue?
    private var completion: Completion

    init(queue: OperationQueue, completion: Completion) {
        self.queue = queue
        self.completion = completion
    }

    func finish(error: SyncError?) {
        if case State.finished = state {
            return
        }

        if let error = error {
            state = .errored(error)
        } else {
            state = .finished
        }
        queue?.cancelAllOperations()
        completion?(state)
    }
}

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
    case updateRelationsFailed(error: Error)
    case upSyncStartSyncFailed(error: Error)
    case upSyncFetchDirtyFailed(error: Error)
    case upSyncSendDirtyFailed(error: Error)
    case upSyncUpdateDirtyFailed(error: Error)
}

class SyncContext {
    typealias Completion = ((State, [SyncError]) -> Void)?

    enum State {
        case `default`
        case finished
    }

    private(set) var state: State = .default
    private var completion: Completion
    private var errors = [SyncError]()
    
    init(queue: OperationQueue, completion: Completion) {
        self.completion = completion
    }
    
    func add(error: SyncError) {
        errors.append(error)
    }

    func finish() {
        if case State.finished = state {
            return
        }

        state = .finished
        completion?(state, errors)
    }
}

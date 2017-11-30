//
//  DownSyncContext.swift
//  QOT
//
//  Created by Sam Wyndham on 26.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum SyncError: Error {

    case didCancel
    case fetchSyncTokenFailed(error: Error)
    case downSyncReadLastSyncDateFailed(type: String, error: Error)
    case downSyncStartSyncFailed(type: String, error: NetworkError)
    case downSyncFetchIntermediatesFailed(type: String, error: NetworkError)
    case downSyncImportChangesFailed(type: String, error: Error)
    case downSyncSaveSyncDateFailed(type: String, error: Error)
    case updateRelationsFailed(error: Error)
    case upSyncStartSyncFailed(error: Error)
    case upSyncFetchDirtyFailed(error: Error)
    case upSyncSendDirtyFailed(error: Error)
    case upSyncUpdateDirtyFailed(error: Error)
}

class SyncContext {
    private(set) var errors = [SyncError]()

    func add(error: SyncError) {
        errors.append(error)
    }
}

//
//  SyncManager.swift
//  QOT
//
//  Created by Sam Wyndham on 29.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy
import Alamofire
import RealmSwift

final class SyncManager {

    let sessionManager: SessionManager
    let syncRecordService: SyncRecordService
    let realmProvider: RealmProvider

    init(sessionManager: SessionManager, syncRecordService: SyncRecordService, realmProvider: RealmProvider) {
        self.sessionManager = sessionManager
        self.syncRecordService = syncRecordService
        self.realmProvider = realmProvider
    }
}

private extension SyncManager {

    func downSyncOperations<T, U>(desciption: SyncDescription<T, U>, context: SyncContext) throws -> [Operation]  where T: JSONDecodable, U: DownSyncable, U: Object {
        let syncType = desciption.syncType
        let lastSync = try syncRecordService.lastSync(type: syncType)
        let networkOp = DownSyncNetworkOperation<T>(context: context, sessionManager: sessionManager, syncType: syncType, lastSyncDate: lastSync)
        let databaseOp = DownSyncDatabaseOperation<U>(context: context, syncType: syncType, storeProvider: realmProvider)
        let recordSyncOp = RecordSyncOperation<U>(context: context, service: syncRecordService, type: syncType)

        return [networkOp, databaseOp, recordSyncOp]
    }

    // MARK: Syncs

    func contentCategoryDownOperations(context: SyncContext) throws -> [Operation] {
        return try downSyncOperations(desciption: ContentCategoryDown, context: context)
    }
}

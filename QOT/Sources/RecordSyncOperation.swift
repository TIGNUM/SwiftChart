//
//  RecordSyncOperation.swift
//  QOT
//
//  Created by Sam Wyndham on 29.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class RecordSyncOperation<T>: Operation where T: DownSyncable, T: Object  {

    private let context: SyncContext
    private let service: SyncRecordService
    private let type: SyncType

    init(context: SyncContext, service: SyncRecordService, type: SyncType) {
        self.context = context
        self.service = service
        self.type = type
        super.init()
    }

    override func main() {
        guard let result = context[type.rawValue] as? DownSyncNetworkResult<T.Data>, let date = context[.syncDate] as? Int64 else {
            preconditionFailure("No results")
        }

        do {
            try service.recordSync(type: type, date: date)
        } catch let error {
            context.syncFailed(error: error)
        }
    }
}

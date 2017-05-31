//
//  DownSyncContext.swift
//  QOT
//
//  Created by Sam Wyndham on 26.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class SyncContext {
    weak var queue: OperationQueue?
    var data: [String: Any] = [:]
    private(set) var errors: [Error] = []

    init(queue: OperationQueue) {
        self.queue = queue
    }

    func syncFailed(error: Error) {
        errors.append(error)
        queue?.cancelAllOperations()
    }
}

//
//  DownSyncContext.swift
//  QOT
//
//  Created by Sam Wyndham on 26.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class SyncContext {
    let baseURL: URL
    weak var queue: OperationQueue?
    var data: [String: Any] = [:]
    private(set) var errors: [Error] = []

    init(baseURL: URL, queue: OperationQueue) {
        self.baseURL = baseURL
    }

    func syncFailed(error: Error) {
        errors.append(error)
        queue?.cancelAllOperations()
    }
}

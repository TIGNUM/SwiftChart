//
//  DownSyncContext.swift
//  QOT
//
//  Created by Sam Wyndham on 26.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class SyncContext {
    enum DataKey: String {
        case syncToken
        case syncDate
    }

    private var data: [String: Any] = [:]

    weak var queue: OperationQueue?
    private(set) var errors: [Error] = []

    init(queue: OperationQueue) {
        self.queue = queue
    }

    func syncFailed(error: Error) {
        errors.append(error)
        queue?.cancelAllOperations()
    }

    subscript(key: DataKey) -> Any? {
        get {
            return data[key.rawValue]
        }
        set {
            data[key.rawValue] = newValue
        }
    }

    subscript(key: String) -> Any? {
        get {
            return data[key]
        }
        set {
            data[key] = newValue
        }
    }
}

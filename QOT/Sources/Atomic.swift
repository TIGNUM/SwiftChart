//
//  Atomic.swift
//  QOT
//
//  Created by Sam Wyndham on 01/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class Atomic<T> {

    private let lock = DispatchSemaphore(value: 1)
    private var _value: T

    init(_ value: T) {
        self._value = value
    }

    var value: T {
        get {
            lock.wait()
            defer { lock.signal() }
            return _value
        }
        set {
            lock.wait()
            defer { lock.signal() }
            _value = newValue
        }
    }
}

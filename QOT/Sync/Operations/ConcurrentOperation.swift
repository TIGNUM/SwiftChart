//
//  OperationState.swift
//  QOT
//
//  Created by Sam Wyndham on 26.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

/// An abstract superclass or concurrent operations.
class ConcurrentOperation: Operation {

    private enum State {
        case ready, executing, finished
    }

    private enum KVOKey: String {
        case isExecuting, isFinished
    }

    private let lock = NSLock()
    private var _state: State = .ready

    private var state: State {
        get {
            let current: State
            lock.lock()
            current = _state
            lock.unlock()
            return current
        }
        set {
            lock.lock()

            guard _state != newValue else {
                return
            }

            let kvoKey: String
            switch newValue {
            case .ready:
                fatalError("Operations are not reusable")
            case .executing:
                kvoKey = KVOKey.isExecuting.rawValue
            case .finished:
                kvoKey = KVOKey.isFinished.rawValue
            }

            willChangeValue(forKey: kvoKey)
            _state = newValue
            didChangeValue(forKey: kvoKey)

            lock.unlock()
        }
    }

    // MARK: Overides

    final override func start() {
        if isCancelled {
            state = .finished
        } else {
            state = .executing
            execute()
        }
    }

    final override var isConcurrent: Bool {
        return true
    }

    final override var isReady: Bool {
        return state == .ready
    }

    final override var isExecuting: Bool {
        return state == .executing
    }

    final override var isFinished: Bool {
        return state == .finished
    }

    /// The entry point of all subclass operations. Sublasses must call `finish` when complete.
    func execute() {
        fatalError("Super should not be called")
    }

    final func finish() {
        state = .finished
    }

}

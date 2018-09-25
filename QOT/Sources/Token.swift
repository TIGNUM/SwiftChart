//
//  Token.swift
//  QOT
//
//  Created by Sam Wyndham on 16.11.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveKit

protocol TokenProtocol: class {

    func invalidate()
}

final class Token: TokenProtocol {

    private let lock = NSLock()
    private var valid = Atomic(true)

    func invalidate() {
        valid.value = false
    }

    func isValid() -> Bool {
        return valid.value
    }
}

final class BlockToken: TokenProtocol {

    private let closure: () -> Void

    init(invalidation: @escaping () -> Void) {
        self.closure = invalidation
    }

    func invalidate() {
        closure()
    }
}

final class TokenBin {

    private var tokens: [ObjectIdentifier: TokenProtocol] = [:]

    func addToken(_ token: TokenProtocol) {
        tokens[ObjectIdentifier(token)] = token
    }

    func disposeToken(_ token: TokenProtocol) {
        token.invalidate()
        tokens[ObjectIdentifier(token)] = nil
    }

    func disposeAll() {
        tokens.forEach { $0.value.invalidate() }
        tokens = [:]
    }

    deinit {
        disposeAll()
    }
}

extension NSKeyValueObservation: TokenProtocol {}

extension CompositeDisposable: TokenProtocol {

    func invalidate() {
        dispose()
    }
}

extension NotificationToken: TokenProtocol {

}

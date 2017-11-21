//
//  Token.swift
//  QOT
//
//  Created by Sam Wyndham on 16.11.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

protocol Token: class {
    
    func invalidate()
}

extension Token {
    
    func addTo(_ bin: TokenBin) {
        bin.addToken(self)
    }
}

final class TokenBin {
    
    private var tokens: [ObjectIdentifier: Token] = [:]
    
    func addToken(_ token: Token) {
        tokens[ObjectIdentifier(token)] = token
    }
    
    func disposeToken(_ token: Token) {
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

extension NSKeyValueObservation: Token {}

extension NotificationToken: Token {
    
    func invalidate() {
        stop()
    }
}

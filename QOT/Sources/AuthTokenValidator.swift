//
//  AuthTokenValidator.swift
//  QOT
//
//  Created by Sam Wyndham on 02/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import JWT

struct AuthTokenValidator {

    let expirationLeeway: TimeInterval

    init(expirationLeeway: TimeInterval = TimeInterval(minutes: 60)) {
        self.expirationLeeway = expirationLeeway
    }

    func isValid(token: String, now: Date) -> Bool {
        do {
            let claims: ClaimSet = try JWT.decode(token, algorithm: .none, verify: false)
            if let expiration = claims.expiration {
                let timeIntervalUntilExpiry = expiration.timeIntervalSince(now)
                return timeIntervalUntilExpiry > expirationLeeway
            } else {
                assertionFailure("ASSUMPTION - Auth tokens MUST have an expiration")
                log("Authentication token has no expiration: \(token)", level: .error)
                return false
            }
        } catch {
            log("Failed to decode authentication token: \(token), error: \(error)", level: .error)
            return false
        }
    }
}

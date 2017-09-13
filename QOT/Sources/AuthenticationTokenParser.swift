//
//  AuthenticationTokenParser.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

struct AuthenticationTokenParser {

    enum Error: Swift.Error {
        case failedToCreateTokenFromData(data: Data)
    }

    static func parse(_ data: Data) throws -> String {
        guard let token = String(data: data, encoding: .utf8) else {
            throw Error.failedToCreateTokenFromData(data: data)
        }
        return token
    }

    static func make(username: String, password: String) -> (Data) throws -> Credential {
        return { (data) in
            guard let token = String(data: data, encoding: .utf8) else {
                throw Error.failedToCreateTokenFromData(data: data)
            }
            return Credential(username: username, password: password, token: token)
        }
    }
}

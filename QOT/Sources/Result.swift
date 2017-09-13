//
//  Result.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum Result<Value, Error: Swift.Error> {

    case success(Value)
    case failure(Error)

    var value: Value? {
        guard case Result.success(let value) = self else {
            return nil
        }
        return value
    }

    var error: Error? {
        guard case Result.failure(let error) = self else {
            return nil
        }
        return error
    }
}

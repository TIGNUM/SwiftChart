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
}

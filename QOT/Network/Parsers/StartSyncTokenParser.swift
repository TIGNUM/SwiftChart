//
//  StartSyncTokenParser.swift
//  QOT
//
//  Created by Sam Wyndham on 30.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct StartSyncTokenParser {

    static func parse(_ data: Data) throws -> String {
        let json = try JSON(data: data)
        let token: String = try json.getItemValue(at: .nextSyncToken)
        return token
    }
}

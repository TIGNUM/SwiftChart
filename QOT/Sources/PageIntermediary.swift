//
//  PageIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 15.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct PageIntermediary: JSONDecodable {

    let name: String
    let displayName: String?
    let layoutInfo: String?

    init(json: JSON) throws {
        self.name = try json.getItemValue(at: .name)
        self.displayName = try json.getItemValue(at: .displayName)
        self.layoutInfo = try json.serializeString(at: .layoutInfo)
    }
}

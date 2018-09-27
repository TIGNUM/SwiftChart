//
//  ContentItemSharing.swift
//  QOT
//
//  Created by Sanggeon Park on 29.08.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct ContentItemSharing {

    let title: String
    let url: String
    let body: String

    init(json: JSON) throws {
        title = try json.getItemValue(at: .title) ?? ""
        url = try json.getItemValue(at: .url) ?? ""
        body = try json.getItemValue(at: .body) ?? ""
    }

    static func parse(_ data: Data) throws -> ContentItemSharing {
        return try ContentItemSharing(json: try JSON(data: data))
    }
}

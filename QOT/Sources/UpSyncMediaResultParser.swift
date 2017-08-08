//
//  UpSyncMediaResultParser.swift
//  QOT
//
//  Created by Lee Arromba on 08/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct UpSyncMediaResult {
    
    let remoteID: Int
    let remoteURLString: String
    
    init(json: JSON) throws {
        guard let result = try json.getArray(at: .resultList, fallback: []).first else {
            throw SimpleError(localizedDescription: "missing resultList[0]")
        }
        self.remoteID = try result.getItemValue(at: .id)
        self.remoteURLString = try result.getItemValue(at: .mediaUrl)
    }
}

struct UpSyncMediaResultParser {
    
    static func parse(_ data: Data) throws -> UpSyncMediaResult {
        let json = try JSON(data: data)
        return try UpSyncMediaResult(json: json)
    }
}

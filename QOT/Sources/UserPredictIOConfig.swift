//
//  UserPredictIOConfig.swift
//  QOT
//
//  Created by karmic on 10.08.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct UserPredictIOConfig {

    // MARK: - Properties

    let webHookURL: String
    var customParameters = [String: String]()

    // MARK: - Init

    init(json: JSON) throws {
        webHookURL = try json.getItemValue(at: .webhookURL)
        let tempParameters: [String: JSON] = try json.getDictionary(at: "customParameter")
        tempParameters.keys.forEach { (key: String) in
            customParameters[key] = tempParameters[key]?.description
        }
    }

    static func parse(_ data: Data) throws -> UserPredictIOConfig {
        return try UserPredictIOConfig(json: try JSON(data: data))
    }
}

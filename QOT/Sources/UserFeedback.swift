//
//  UserFeedback.swift
//  QOT
//
//  Created by Lee Arromba on 28/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class UserFeedback: SyncableObject {

    @objc private(set) dynamic var message: String = ""

    convenience init(message: String) {
        self.init()
        self.message = message
    }
}

extension UserFeedback: OneWaySyncableUp {
    
    static var endpoint: Endpoint {
        return .userFeedback
    }

    func toJson() -> JSON? {
        let dict: [JsonKey: JSONEncodable] = [
            .message: message
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}

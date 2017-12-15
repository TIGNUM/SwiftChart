//
//  Guide.swift
//  QOT
//
//  Created by karmic on 11.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class Guide: SyncableObject {

    @objc dynamic var planID: String = ""

    @objc dynamic var greeting: String = ""

    @objc dynamic var planingTime: String  = ""

    @objc dynamic var deleted: Bool = false

    @objc dynamic var changeStamp: String? = UUID().uuidString

    var items = List<GuideItem>()
}

extension Guide: TwoWaySyncable {

    func setData(_ data: GuideIntermediary, objectStore: ObjectStore) throws {

    }

    func toJson() -> JSON? {
        let dict: [JsonKey: JSONEncodable] = [:]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }

    static var endpoint: Endpoint {
        return .guide
    }
}

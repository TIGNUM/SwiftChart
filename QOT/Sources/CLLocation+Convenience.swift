//
//  CLLocation+Convenience.swift
//  QOT
//
//  Created by karmic on 22.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import CoreLocation
import Freddy

extension CLLocation {

    func toJson() -> [JSON]? {
        let dateFormatter = DateFormatter.iso8601
        let dict: [JsonKey: JSONEncodable] = [
            .createdAt: dateFormatter.string(from: Date()),
            .attitude: altitude,
            .latitude: coordinate.latitude,
            .longitude: coordinate.longitude,
            .verticalAccuracy: verticalAccuracy,
            .horizontalAccuracy: horizontalAccuracy,
            .floor: (floor?.level).toJSONEncodable
        ]

        return [.dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))]
    }
}

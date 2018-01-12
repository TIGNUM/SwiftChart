//
//  RealmStatisticsThreshold.swift
//  QOT
//
//  Created by Sam Wyndham on 10/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmStatisticsThreshold: Object {

    @objc private(set) dynamic var colorState: String = ""

    let min = RealmOptional<Double>(nil)

    let max = RealmOptional<Double>(nil)

    convenience init(threshold: StatisticsIntermediary.Threshold) {
        self.init()

        colorState = threshold.colorState
        min.value = threshold.min
        max.value = threshold.max
    }

    func delete() {
        if let realm = realm {
            realm.delete(self)
        }
    }
}

extension RealmStatisticsThreshold {

    enum Color: String {
        case low = "LOW"
        case normal = "NORMAL"
        case critical = "CRITICAL"

        init(string: String) {
            self = Color(rawValue: string) ?? .normal
        }
    }

    var color: Color {
        return Color(string: colorState)
    }
}

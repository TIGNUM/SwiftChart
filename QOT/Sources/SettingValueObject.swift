//
//  SettingValue.swift
//  QOT
//
//  Created by Sam Wyndham on 07.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class SettingValueObject: Object {

    // MARK: Private Properties

    let _int = RealmOptional<Int>(nil)

    let _min = RealmOptional<Int>(nil)

    let _max = RealmOptional<Int>(nil)

    // MARK: Public Properties

    @objc private(set) dynamic var format: String = ""

    @objc private(set) dynamic var text: String?

    @objc private(set) dynamic var from: Date?

    @objc private(set) dynamic var to: Date?

    @objc private(set) dynamic var bool: Bool = false

    @objc private(set) dynamic var workingDays: Bool = false

    @objc private(set) dynamic var weekend: Bool = false

    @objc private(set) dynamic var publicHolidays: Bool = false

    @objc private(set) dynamic var vacation: Bool = false

    var int: Int? {
        return _int.value
    }

    var min: Int? {
        return _min.value
    }

    var max: Int? {
        return _max.value
    }

    convenience init(with value: SettingValue) {
        self.init()

        switch value {
        case .text(let text):
            self.text = text
        case .bool(let bool):
            self.bool = bool
        case .int(let int, let min, let max):
            self._int.value = int
            self._min.value = min
            self._max.value = max
        case .occurrence(let from, let to, let workingDays, let weekend, let publicHolidays, let vacation):
            self.from = from
            self.to = to
            self.workingDays = workingDays
            self.weekend = weekend
            self.publicHolidays = publicHolidays
            self.vacation = vacation
        default:
            break
        }
        self.format = value.format.map { $0.rawValue } ?? ""
    }

    func delete() {
        if let realm = realm {
            realm.delete(self)
        }
    }
}

//
//  GuideTime.swift
//  QOT
//
//  Created by karmic on 14.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmGuideTime: Object {

    @objc dynamic var hour: Int = 0

    @objc dynamic var minute: Int = 0

    convenience init(_ data: GuideTimeIntermediary) {
        self.init()

        self.hour = data.hour
        self.minute = data.minute
    }
}

extension RealmGuideTime {

    /// Returns new `Date` by setting `hour` and `minute` on input date using current calendar.
    func date(with inputDate: Date) -> Date? {
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: inputDate)
    }
}

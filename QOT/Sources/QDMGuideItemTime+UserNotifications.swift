//
//  QDMGuideItemTime+UserNotifications.swift
//  QOT
//
//  Created by Sanggeon Park on 22.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension QDMGuideItemTime {
    func date(with inputDate: Date) -> Date? {
        guard let hour = hour else { return nil }
        return Calendar.current.date(bySettingHour: hour, minute: minute ?? 0, second: 0, of: inputDate)
    }
}

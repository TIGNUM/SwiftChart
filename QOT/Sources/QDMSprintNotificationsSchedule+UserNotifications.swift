//
//  QDMSprintNotificationsSchedule+UserNotifications.swift
//  QOT
//
//  Created by Sanggeon Park on 22.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension QDMSprintNotificationsSchedule {
    var localNotificationDate: Date? {
        return self.date(with: Date())
    }

    func date(with inputDate: Date) -> Date? {
        guard let stringComponents = time?.components(separatedBy: ":") else {
            return nil
        }
        guard let hour = Int(stringComponents.first ?? ""),
        let minute = Int(stringComponents.last ?? "") else {
            return nil
        }
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: inputDate)
    }
}

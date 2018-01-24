//
//  GuideProvider.swift
//  QOT
//
//  Created by Sam Wyndham on 19/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

extension RealmGuideItemNotification: GuideNotificationItem {

    var displayAt: (utcDate: Date, hour: Int, minute: Int)? {
        guard let utcDate = issueDate, let hour = displayTime?.hour, let minute = displayTime?.minute else {
            return nil
        }
        return (utcDate: utcDate, hour: hour, minute: minute)
    }
}

extension RealmGuideItemLearn: GuideLearnItem {

    var displayAt: (hour: Int, minute: Int)? {
        guard let hour = displayTime?.hour, let minute = displayTime?.minute else {
            return nil
        }
        return (hour: hour, minute: minute)
    }
}

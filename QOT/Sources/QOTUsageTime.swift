//
//  QOTUsageTime.swift
//  QOT
//
//  Created by Sam Wyndham on 14.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class QOTUsageTimer {

    private var started: Date?

    static let sharedInstance = QOTUsageTimer()
    var userService: UserService?

    private init() {
        // Don't delete. Ensures that access is though singleton
    }

    func startTimer() {
        self.started = Date()
    }

    func stopTimer() {
        self.started = nil
    }

    var totalSeconds: TimeInterval {
        let oldValue = TimeInterval(userService?.user()?.totalUsageTime ?? 0)
        guard let started = started else {
            /*
             If started is nil the app is not active so just return the oldValue. `totalSeconds` should only reflect
             active time in the app
             */
            return oldValue
        }
        let delta = -started.timeIntervalSinceNow
        return oldValue + delta
    }

    func totalTimeString(_ seconds: TimeInterval) -> String {
        return DateComponentsFormatter.timeIntervalToString(seconds)?.replacingOccurrences(of: ", ", with: "\n").uppercased() ?? R.string.localized.qotUsageTimerDefault()
    }
}

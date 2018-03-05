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
    private var timer: Timer?

    static let sharedInstance = QOTUsageTimer()
    var userService: UserService?

    private init() {
        // Don't delete. Ensures that access is though singleton
    }

    func startTimer() {
        self.started = Date()
        timer = .scheduledTimer(timeInterval: 60.0,
                                target: self,
                                selector: #selector(update),
                                userInfo: nil,
                                repeats: true)
    }

    func stopTimer() {
        self.started = nil
        timer?.invalidate()
    }

    @objc func update() {
        userService?.updateTotalUsageTime(totalSeconds)
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

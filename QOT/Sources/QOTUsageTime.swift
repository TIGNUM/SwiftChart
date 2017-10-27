//
//  QOTUsageTime.swift
//  QOT
//
//  Created by Sam Wyndham on 14.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class QOTUsageTimer {

    private var _started: Date?

    static let sharedInstance = QOTUsageTimer()

    private init() {
        // Don't delete. Ensures that access is though singleton
    }

    func start() {
        if _started == nil {
            _started = Date()
        }
    }

    func stopAndSave() {
        UserDefault.qotUsage.setDoubleValue(value: Double(totalSeconds))
        _started = nil
    }

    var totalSeconds: TimeInterval {
        let oldValue = UserDefault.qotUsage.doubleValue
        let delta = -started.timeIntervalSinceNow

        return TimeInterval(oldValue) + delta
    }

    func totalTimeString(_ seconds: TimeInterval) -> String {
        return DateComponentsFormatter.timeIntervalToString(seconds)?.replacingOccurrences(of: ", ", with: "\n").uppercased() ?? R.string.localized.qotUsageTimerDefault()
    }

    private var started: Date {
        guard let started = _started else {
            assertionFailure("QOTUsageTimer never started")
            // Recover
            let now = Date()
            _started = now
            return now
        }
        return started
    }
}

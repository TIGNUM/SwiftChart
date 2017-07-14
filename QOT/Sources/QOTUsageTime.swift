//
//  QOTUsageTime.swift
//  QOT
//
//  Created by Sam Wyndham on 14.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class QOTUsageTimer {

    private static var started: Date?

    static let sharedInstance = QOTUsageTimer()

    func start() {
        if QOTUsageTimer.started == nil {
            QOTUsageTimer.started = Date()
        }
    }

    func stopAndSave() {
        UserDefault.qotUsage.setDoubleValue(value: Double(totalSeconds))
        QOTUsageTimer.started = nil
    }

    var totalSeconds: TimeInterval {
        let oldValue = UserDefault.qotUsage.doubleValue
        let delta = -started.timeIntervalSinceNow
        return TimeInterval(oldValue) + delta
    }

    private var started: Date {
        guard let started = QOTUsageTimer.started else {
            fatalError("QOTUsageTimer never started")
        }
        return started
    }
}

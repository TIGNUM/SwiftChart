//
//  QOTUsageTime.swift
//  QOT
//
//  Created by Sam Wyndham on 14.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class QOTUsageTimer {

    private var started: Date?
    private let didBecomeActiveHandler = NotificationHandler(name: .UIApplicationDidBecomeActive)
    private let willResignActiveHandler = NotificationHandler(name: .UIApplicationWillResignActive)
    static let sharedInstance = QOTUsageTimer()

    private init() {
        // Don't delete. Ensures that access is though singleton
    }

    func observeUsage() {
        didBecomeActiveHandler.handler = { [unowned self] _ in
            self.started = Date()
        }
        willResignActiveHandler.handler = { [unowned self] _ in
            UserDefault.qotUsage.setDoubleValue(value: Double(self.totalSeconds))
            self.started = nil
        }
    }

    var totalSeconds: TimeInterval {
        let oldValue = UserDefault.qotUsage.doubleValue
        guard let started = started else {
            /*
             If started is nil the app is not active so just return the oldValue. `totalSeconds` should only reflect
             active time in the app
             */
            return oldValue
        }
        let delta = -started.timeIntervalSinceNow
        
        return TimeInterval(oldValue) + delta
    }

    func totalTimeString(_ seconds: TimeInterval) -> String {
        return DateComponentsFormatter.timeIntervalToString(seconds)?.replacingOccurrences(of: ", ", with: "\n").uppercased() ?? R.string.localized.qotUsageTimerDefault()
    }
}

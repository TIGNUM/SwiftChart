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

    func totalTimeString(totalSeconds: Int) -> String {
        let calendar = Calendar.sharedUTC        
        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute]
        formatter.collapsesLargestUnit = true
        let commaSeperatedString = formatter.string(from: TimeInterval(totalSeconds))?.uppercased() ?? "1 MINUTE"
        let trimmedString = commaSeperatedString.replacingOccurrences(of: ", ", with: ",")
        let stringArray = trimmedString.split(separator: ",")

        return stringArray.joined(separator: "\n")
    }

    private var started: Date {
        guard let started = QOTUsageTimer.started else {
            fatalError("QOTUsageTimer never started")
        }

        return started
    }
}

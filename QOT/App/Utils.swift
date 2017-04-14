//
//  Utils.swift
//  QOT
//
//  Created by karmic on 23/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Debug

struct LogSettings {

    enum LogLevel {
        case debug
        case verbose
    }

    static var logLevel: LogLevel = .debug
    static var detailedLogFormat = ">>> :line :className.:function --> :obj"
    static var detailedLogDateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    static fileprivate var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = LogSettings.detailedLogDateFormat
        return formatter
    }
}

// Make
func log(_ obj: @autoclosure () -> Any, enabled: Bool = true, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
        if enabled == true {
            switch LogSettings.logLevel {
            case .debug:
                print(obj())
            case .verbose:
                var logStatement = LogSettings.detailedLogFormat.replacingOccurrences(of: ":line", with: "\(line)")

                if let className = NSURL(string: file)?.lastPathComponent?.components(separatedBy: ".").first {
                    logStatement = logStatement.replacingOccurrences(of: ":className", with: className)
                }

                logStatement = logStatement.replacingOccurrences(of: ":function", with: function)
                logStatement = logStatement.replacingOccurrences(of: ":obj", with: "\(obj())")

                if logStatement.contains(":date") {
                    let replacement = LogSettings.dateFormatter.string(from: Date())
                    logStatement = logStatement.replacingOccurrences(of: ":date", with: "\(replacement)")
                }

                print(logStatement)
            }
        }
    #endif
}

var randomNumber: CGFloat {
    return (CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
}

//
//  Utils.swift
//  QOT
//
//  Created by karmic on 23/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import SwiftyBeaver

struct Log {
    enum Level {
        case verbose
        case debug
        case info
        case warning
        case error
    }

    struct Toggle {
        struct Database {
            static let Content = false
            static let Learn = false
            static let Me = false
            static let Prepare = false
        }
        struct Manager {
            static let API = false
            static let Database = false
            static let Font = false
            static let FileManager = true
            static let TabBar = false
            static let Sync = true
        }
        struct NetworkManager {
            static let requestBody = false
            static let responseBody = false
        }
        struct Analytics {
            static let pageTracking = false
            static let eventTracking = false
        }
        struct Sync {
            static let syncOperation = true
        }
    }

    static var main: SwiftyBeaver.Type {
        return SwiftyBeaver.self
    }

    static var remoteLogLevel: SwiftyBeaver.Level = .error
    static var format = ">>> :line :className.:function --> :obj"
    static var dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }

    static func setup() {
        let console = ConsoleDestination()
        console.format = "$DHH:mm:ss$d $L $M"
        console.minLevel = .verbose
        Log.main.addDestination(console)

        let remoteLog = RemoteLogDestination()
        remoteLog.minLevel = remoteLogLevel
        Log.main.addDestination(remoteLog)

         #if DEBUG
        let file = FileDestination()
        file.minLevel = .debug
        file.logFileURL = URL.documentsDirectory.appendingPathComponent("daily_prep_notification.log")

        Log.main.addDestination(file)
        #endif
    }
}

func log(_ obj: @autoclosure () -> Any, enabled: Bool = true, level: Log.Level = .debug, file: String = #file, function: String = #function, line: Int = #line) {
    guard enabled else {
        return
    }
    switch level {
    case .verbose:
        var logStatement = Log.format.replacingOccurrences(of: ":line", with: "\(line)")

        if let className = NSURL(string: file)?.lastPathComponent?.components(separatedBy: ".").first {
            logStatement = logStatement.replacingOccurrences(of: ":className", with: className)
        }

        logStatement = logStatement.replacingOccurrences(of: ":function", with: function)
        logStatement = logStatement.replacingOccurrences(of: ":obj", with: "\(obj())")

        if logStatement.contains(":date") {
            let replacement = Log.dateFormatter.string(from: Date())
            logStatement = logStatement.replacingOccurrences(of: ":date", with: "\(replacement)")
        }

        Log.main.verbose(obj(), file, function, line: line, context: logStatement)
    case .debug:
        Log.main.debug(obj(), file, function, line: line)
    case .info:
        Log.main.info(obj(), file, function, line: line)
    case .warning:
        Log.main.warning(obj(), file, function, line: line)
    case .error:
        Log.main.error(obj(), file, function, line: line)
    }
}

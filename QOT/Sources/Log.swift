//
//  Utils.swift
//  QOT
//
//  Created by karmic on 23/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import SwiftyBeaver

final class Logger {

    enum Level {
        case verbose
        case debug
        case info
        case warning
        case error
    }

    fileprivate let logger = SwiftyBeaver.self
    let console = ConsoleDestination()
    let remote = RemoteLogDestination()

    #if DEBUG
    let file = FileDestination()
    #endif

    static var shared = Logger()

    func setup() {
        console.minLevel = .verbose // <<<<<<<<<<<<<< Change log level here (.verbose prints everything)
        logger.addDestination(console)

        remote.minLevel = .error
        //logger.addDestination(remote)

        #if DEBUG
            file.minLevel = .debug
            file.logFileURL = URL.documentDirectory.appendingPathComponent("qot.log")
            logger.addDestination(file)
        #endif
    }
}

func log(_ message: @autoclosure () -> Any,
         level: Logger.Level = .info,
         file: String = #file,
         function: String = #function,
         line: Int = #line) {
    let logger =  Logger.shared.logger
    switch level {
    case .verbose:
        logger.verbose(message, file, function, line: line)
    case .debug:
        logger.debug(message, file, function, line: line)
    case .info:
        logger.info(message, file, function, line: line)
    case .warning:
        logger.warning(message, file, function, line: line)
    case .error:
        logger.error(message, file, function, line: line)
    }
}

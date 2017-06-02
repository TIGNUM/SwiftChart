//
//  NetworkError.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Alamofire

enum HTTPStatusCode: Int {
    case unauthorized = 401
}

enum NetworkError: Error {
    
    case failedToParseData(Data, error: Error)
    case unknown(error: Error, statusCode: Int?)
    case noNetworkConnection
    case cancelled
    case unauthenticated

    init(error: NSError, statusCode: Int?) {
        if let code = statusCode {
            if let httpStatusCode = HTTPStatusCode(rawValue: code), httpStatusCode == .unauthorized {
                self = .unauthenticated
            } else {
                self = .unknown(error: error, statusCode: code)
            }
        } else if error.domain == NSURLErrorDomain {
            switch error.code {
            case NSURLErrorNotConnectedToInternet: self = .noNetworkConnection
            case NSURLErrorCancelled: self = .cancelled
            case NSURLErrorUserAuthenticationRequired: self = .unauthenticated
            default: self = .unknown(error: error, statusCode: nil)
            }
        } else {
            self = .unknown(error: error, statusCode: nil)
        }
    }
}

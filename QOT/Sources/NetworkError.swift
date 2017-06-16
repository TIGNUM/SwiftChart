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

struct NetworkError: Error {

    enum NetworkErrorType {
        case failedToParseData(Data, error: Error)
        case unknown(error: Error, statusCode: Int?)
        case noNetworkConnection
        case cancelled
        case unauthenticated
    }

    let type: NetworkErrorType
    let request: URLRequest?
    let response: URLResponse?

    init(type: NetworkErrorType) {
        self.type = type
        self.request = nil
        self.response = nil
    }

    init(error: NSError, request: URLRequest?, response: HTTPURLResponse?) {
        if let code = response?.statusCode {
            if let httpStatusCode = HTTPStatusCode(rawValue: code), httpStatusCode == .unauthorized {
                type = .unauthenticated
            } else {
                type = .unknown(error: error, statusCode: code)
            }
        } else if error.domain == NSURLErrorDomain {
            switch error.code {
            case NSURLErrorNotConnectedToInternet: type = .noNetworkConnection
            case NSURLErrorCancelled: type = .cancelled
            case NSURLErrorUserAuthenticationRequired: type = .unauthenticated
            default: type = .unknown(error: error, statusCode: nil)
            }
        } else {
            type = .unknown(error: error, statusCode: nil)
        }

        self.request = request
        self.response = response
    }
}

extension NetworkError.NetworkErrorType: CustomDebugStringConvertible {

    var debugDescription: String {
        switch self {
        case .failedToParseData(let data, let error):
            let dataString = String(data: data, encoding: .utf8) ?? "Unable to decode data to string"
            return "Failed to parse data: \(dataString), error: \(error)"
        case .cancelled:
            return "Request cancelled"
        case .noNetworkConnection:
            return "No network connection"
        case .unauthenticated:
            return "Unauthenticated"
        case .unknown(let error, let statusCode):
            return "Unknow error: \(error), status code: \(String(describing: statusCode))"
        }
    }
}

extension NetworkError: CustomDebugStringConvertible {

    var debugDescription: String {
        let requestDescription = request?.debugDescription ?? "none"
        let responseDescription = response?.debugDescription ?? "none"
        let errorType = type.debugDescription
        return "NETWORK ERROR - \(errorType), REQUEST: \(requestDescription), RESPONSE: \(responseDescription)"
    }
}

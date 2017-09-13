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
    case notFound = 404
}

struct NetworkError: Error {

    enum NetworkErrorType {
        case failedToParseData(Data, error: Error)
        case unknown(error: Error, statusCode: Int?)
        case noNetworkConnection
        case cancelled
        case unauthenticated
        case notFound
    }

    let type: NetworkErrorType
    let request: URLRequest?
    let response: HTTPURLResponse?
    let data: Data?

    init(type: NetworkErrorType, request: URLRequest? = nil, response: HTTPURLResponse? = nil, data: Data? = nil) {
        self.type = type
        self.request = request
        self.response = response
        self.data = data
    }

    init(error: NSError, request: URLRequest?, response: HTTPURLResponse?, data: Data?) {
        if let code = response?.statusCode {
            let httpStatusCode = HTTPStatusCode(rawValue: code)
            if httpStatusCode == .unauthorized {
                type = .unauthenticated
            } else if httpStatusCode == .notFound {
                type = .notFound
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
        self.data = data
    }

    static func isUnauthenticatedNetworkError(_ error: Error) -> Bool {
        guard let error = error as? NetworkError, case NetworkErrorType.unauthenticated = error.type else {
            return false
        }
        return true
    }
}

extension Error {

    var networkError: NetworkError {
        guard let error = self as? NetworkError else {
            return NetworkError(type: .unknown(error: self, statusCode: nil))
        }
        return error
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
        case .notFound:
            return "404 Not Found"
        }
    }
}

extension NetworkError: CustomDebugStringConvertible {

    var debugDescription: String {
        let requestDescription = request?.debugDescription ?? "none"
        let responseDescription = response?.debugDescription ?? "none"
        let errorType = type.debugDescription
        let dataDescription = data?.utf8String ?? "none"
        return "NETWORK ERROR - \(errorType), REQUEST: \(requestDescription), RESPONSE: \(responseDescription), DATA: \(dataDescription)"
    }
}

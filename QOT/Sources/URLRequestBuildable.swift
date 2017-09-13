//
//  URLRequestBuildable.swift
//  QOT
//
//  Created by Sam Wyndham on 31.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Alamofire

protocol URLRequestBuildable {

    var endpoint: Endpoint { get }
    var httpMethod: HTTPMethod { get }
    var headers: [HTTPHeader: String] { get }
    var paramaters: [RequestParameter: Any] { get }
    var body: Data? { get }
    var requiresAuthentication: Bool { get }
}

extension URLRequestBuildable {

    var httpMethod: HTTPMethod {
        return .get
    }

    var headers: [HTTPHeader: String] {
        return [:]
    }
    
    var paramaters: [RequestParameter: Any] {
        return [:]
    }

    var body: Data? {
        return nil
    }

    var requiresAuthentication: Bool {
        return true
    }
}

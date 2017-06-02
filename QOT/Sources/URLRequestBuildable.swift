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
    var paramaters: [RequestParameter: Any] { get}
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
}

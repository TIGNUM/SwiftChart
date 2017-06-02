//
//  URLRequestBuilder.swift
//  QOT
//
//  Created by Sam Wyndham on 31.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Alamofire

final class URLRequestBuilder {

    let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func make(with buildable: URLRequestBuildable, authToken: String) -> URLRequest {
        var httpHeaders = buildable.headers
        httpHeaders[.conentType] = "application/json"
        httpHeaders[.authToken] = authToken

        let url = buildable.endpoint.url(baseURL: baseURL)
        let method = buildable.httpMethod
        let headers = httpHeaders.mapKeys { $0.rawValue }
        let params = buildable.paramaters.mapKeys { $0.rawValue }

        return URLRequest(url: url, method: method, headers: headers, parameters: params)
    }

    func authentication(username: String, password: String) -> URLRequest {
        let url = Endpoint.authentication.url(baseURL: baseURL)
        let headers = [HTTPHeader.Authorization.rawValue: "\(username):\(password)"]

        return URLRequest(url: url, method: .post, headers: headers, parameters: nil)
    }
}

extension URLRequest {

    init(url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders? = nil, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default) {
        do {
            let request = try URLRequest(url: url, method: method, headers: headers)
            self = try encoding.encode(request, with: parameters)
        } catch let error {
            fatalError("Cannot create URLRequest: \(error)")
        }
    }
}

// MARK: Private helpers

private extension Dictionary {
    func mapKeys<T>(_ transform: (Key) -> T) -> [T: Value] {
        var result: [T: Value] = [:]
        for (key, value) in self {
            result[transform(key)] = value
        }
        return result
    }
}

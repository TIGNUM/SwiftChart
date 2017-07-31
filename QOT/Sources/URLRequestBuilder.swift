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
    let deviceID: String
    let appVersion: String

    init(baseURL: URL, deviceID: String) {
        self.baseURL = baseURL
        self.deviceID = deviceID
        self.appVersion = Bundle.main.versionNumber
    }

    func make(with buildable: URLRequestBuildable, authToken: String?) -> URLRequestConvertible {
        var httpHeaders = buildable.headers
        httpHeaders[.contentType] = "application/json"
        if let authToken = authToken {
            httpHeaders[.authToken] = authToken
        }
        httpHeaders[.deviceID] = deviceID
        httpHeaders[.version] = appVersion

        let url = buildable.endpoint.url(baseURL: baseURL)
        let method = buildable.httpMethod
        let headers = httpHeaders.mapKeys { $0.rawValue }
        let params = buildable.paramaters.mapKeys { $0.rawValue }

        return URLRequest(url: url, method: method, headers: headers, parameters: params, body: buildable.body)
    }
}

extension URLRequest {

    init(url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders? = nil, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default, body: Data? = nil) {
        do {
            let request = try URLRequest(url: url, method: method, headers: headers)
            self = try encoding.encode(request, with: parameters)

            if let body = body {
                self.httpBody = body
            }
        } catch let error {
            fatalError("Cannot create URLRequest: \(error)")
        }
    }
}

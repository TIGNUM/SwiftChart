//
//  URLRequestBuilder.swift
//  QOT
//
//  Created by Sam Wyndham on 31.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Alamofire

final class URLRequestBuilder {

    let deviceID: String
    let build = Bundle.main.buildNumber
    let version = Bundle.main.versionNumber
    let osVersion = ProcessInfo.processInfo.operatingSystemVersion

    init(deviceID: String) {
        self.deviceID = deviceID
    }

    func make(buildable: URLRequestBuildable, authToken: String? = nil) -> URLRequestConvertible {
        if buildable.requiresAuthentication && authToken == nil {
//            assertionFailure("\(buildable) needs authToken")
        }

        var httpHeaders = buildable.headers
        httpHeaders[.authToken] = authToken
        httpHeaders[.contentType] = "application/json"
        httpHeaders[.deviceID] = deviceID
        httpHeaders[.versionPlain] = version
        httpHeaders[.versionX] = version
        httpHeaders[.build] = build
        #if DEBUG
        httpHeaders[.bundleIdentifier] = "DEV.DEBUG." + (Bundle.main.bundleIdentifier ?? "UNKNOWN")
        #else
        httpHeaders[.bundleIdentifier] = Bundle.main.bundleIdentifier
        #endif
        httpHeaders[.os] = "iOS \(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"

        let url = buildable.endpoint.url(baseURL: environment.baseURL)
        let method = buildable.httpMethod
        let headers = httpHeaders.mapKeys { $0.rawValue }
        let params = buildable.paramaters.mapKeys { $0.rawValue }
        let body = buildable.body

        return URLRequest(url: url, method: method, headers: headers, parameters: params, body: body)
    }
}

private extension URLRequest {

    init(url: URL,
         method: HTTPMethod,
         headers: HTTPHeaders? = nil,
         parameters: Parameters? = nil,
         encoding: ParameterEncoding = JSONEncoding.default,
         body: Data? = nil) {
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

//
//  Requests.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Alamofire

extension URLRequest {

    static func authentication(baseURL: URL, username: String, password: String) -> URLRequest {
        let endpoint = Endpoint.authentication
        var request = URLRequest(url: endpoint.url(baseURL: baseURL))
        request.setValue("\(username):\(password)", forHTTPHeaderField: HeaderField.Authorization.rawValue)
        request.httpMethod = HTTPMethod.post.rawValue
        return request
    }

    static func downSyncRequest(url: URL, token: String, from: Date?, to: Date, page: Int) -> URLRequest {
        var params = Parameters()
        params[RequestParameter.fromDate.rawValue] = from
        params[RequestParameter.toDate.rawValue] = to
        params[RequestParameter.pageSize.rawValue] = 50
        params[RequestParameter.page.rawValue] = page
        return URLRequest(url: url, method: .get, parameters: params)
    }

    init(url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders? = nil, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default) {
        do {
            let request = try URLRequest(url: url, method: method, headers: headers)
            self = try encoding.encode(request, with: parameters)
        } catch let error {
            fatalError("Cannot create URLRequest: \(error)")
        }
    }
}

private enum HeaderField: String {

    case Authorization
    case token
}

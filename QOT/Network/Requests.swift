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
        request.httpMethod = RequestMethod.POST.rawValue
        return request
    }
}

private enum HeaderField: String {

    case Authorization
}

private enum RequestMethod: String {

    case GET
    case POST
}

